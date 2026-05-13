/// BLE-driven panic trigger.
///
/// Implements [PanicTriggerService] (the same interface
/// [ManualPanicTriggerService] uses) so it slots into [CompositeTriggerService]
/// alongside the manual button, shake detector, notification action, etc.
///
/// Lifecycle:
///   * `armSystem()` — load paired devices from the server, then scan + connect
///     to each one and subscribe to its panic_trigger notify characteristic.
///     Re-runs every 30s to pick up newly-paired devices and re-attach to
///     keychains that wandered out of range.
///   * On panic notify — parse the JSON payload, emit a [TriggerEvent] (which
///     the composite trigger forwards to [panicNotifier]), then write "ack"
///     back to the keychain so its firmware suppresses the WiFi-fallback.
///   * `disarmSystem()` — cancel the poll timer, unsubscribe and disconnect
///     every active link, close the event stream.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:my_panic/features/keychain/data/keychain_bluetooth_repository.dart';
import 'package:my_panic/features/keychain/data/keychain_device_repository.dart';
import 'package:my_panic/features/trigger_engine/abstract_trigger_source.dart';

part 'ble_panic_trigger_service.g.dart';

class BlePanicTriggerService implements PanicTriggerService {
  BlePanicTriggerService(this._bleRepo, this._deviceRepo);

  final KeychainBluetoothRepository _bleRepo;
  final KeychainDeviceRepository _deviceRepo;

  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();
  final Map<String, _DeviceLink> _links = {};
  Timer? _pollTimer;
  bool _isArmed = false;

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    if (_isArmed) return;
    _isArmed = true;
    developer.log('arming BLE keychain listener', name: 'BlePanicTrigger');

    // Kick off immediately, then every 30s. Each tick is best-effort — a
    // failure (network blip, BLE off, no paired devices) is logged and the
    // next tick retries.
    _refresh();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _refresh(),
    );
  }

  @override
  void disarmSystem() {
    if (!_isArmed) return;
    _isArmed = false;
    developer.log('disarming BLE keychain listener', name: 'BlePanicTrigger');

    _pollTimer?.cancel();
    _pollTimer = null;
    for (final link in _links.values) {
      link.dispose();
    }
    _links.clear();
  }

  Future<void> _refresh() async {
    if (!_isArmed) return;
    try {
      final paired = await _deviceRepo.listDevices();
      for (final d in paired) {
        if (_links.containsKey(d.hardwareId)) continue; // already linked
        // Fire-and-forget — connect attempts that fail just retry next tick.
        unawaited(_tryConnect(d.hardwareId));
      }
    } catch (e, st) {
      developer.log(
        'listDevices failed; will retry next tick',
        name: 'BlePanicTrigger',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> _tryConnect(String hardwareId) async {
    if (!_isArmed) return;
    try {
      // Scan briefly for the device. flutter_blue_plus filters scans by
      // service UUID, so the central only sees MyPanic devices.
      final result = await _bleRepo
          .scan(timeout: const Duration(seconds: 6))
          .map((batch) {
            for (final r in batch) {
              if (r.device.platformName == hardwareId) return r;
            }
            return null;
          })
          .firstWhere((r) => r != null, orElse: () => null);

      await _bleRepo.stopScan();
      if (result == null) {
        return; // not in range right now — try next tick
      }

      final chars = await _bleRepo.connect(result.device);
      final link = _DeviceLink(
        hardwareId: hardwareId,
        chars: chars,
        onPanic: (payload) => _handlePanic(hardwareId, chars, payload),
        onDisconnected: () {
          developer.log(
            'keychain $hardwareId disconnected',
            name: 'BlePanicTrigger',
          );
          _links.remove(hardwareId);
        },
        bleRepo: _bleRepo,
      );
      _links[hardwareId] = link;
      await link.start();
      developer.log(
        'keychain $hardwareId connected + subscribed',
        name: 'BlePanicTrigger',
      );
    } catch (e, st) {
      developer.log(
        'connect to $hardwareId failed; will retry next tick',
        name: 'BlePanicTrigger',
        error: e,
        stackTrace: st,
      );
      _links.remove(hardwareId);
    }
  }

  Future<void> _handlePanic(
    String hardwareId,
    KeychainCharacteristics chars,
    String rawPayload,
  ) async {
    if (!_isArmed) return;

    // The firmware emits JSON { device_id, ts, batt, key }. We pass `key` as
    // the idempotency key so if both BLE and WiFi-fallback paths reach the
    // server, they collapse to one alert via the existing uniqueness check.
    Map<String, dynamic>? payload;
    try {
      payload = jsonDecode(rawPayload) as Map<String, dynamic>;
    } catch (e) {
      developer.log(
        'BLE panic payload was not JSON: $rawPayload',
        name: 'BlePanicTrigger',
        error: e,
      );
    }

    final idempotencyKey =
        payload?['key'] as String? ?? 'ble-${DateTime.now().millisecondsSinceEpoch}';

    developer.log(
      'BLE panic from $hardwareId key=$idempotencyKey',
      name: 'BlePanicTrigger',
    );

    final event = TriggerEvent(
      timestamp: DateTime.now(),
      source: TriggerSource.ble,
      metadata: {
        'hardware_id': hardwareId,
        'idempotency_key': idempotencyKey,
        if (payload?['batt'] != null) 'battery_pct': payload!['batt'],
      },
    );
    _triggerController.add(event);

    // Ack back to suppress the firmware's WiFi-fallback. Best-effort —
    // if the BLE write fails, the firmware will fall back to WiFi and the
    // server's idempotency key collapse will still result in one alert.
    try {
      await _bleRepo.sendAck(chars);
    } catch (e, st) {
      developer.log(
        'sendAck failed for $hardwareId',
        name: 'BlePanicTrigger',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  void dispose() {
    disarmSystem();
    _triggerController.close();
  }
}

/// Bookkeeping for a single connected keychain. Holds the BLE characteristic
/// handles, the notification stream subscription, and the disconnect listener.
class _DeviceLink {
  _DeviceLink({
    required this.hardwareId,
    required this.chars,
    required this.onPanic,
    required this.onDisconnected,
    required this.bleRepo,
  });

  final String hardwareId;
  final KeychainCharacteristics chars;
  final void Function(String payload) onPanic;
  final void Function() onDisconnected;
  final KeychainBluetoothRepository bleRepo;

  StreamSubscription<String>? _notifySub;
  StreamSubscription<BluetoothConnectionState>? _stateSub;

  Future<void> start() async {
    _notifySub = bleRepo.subscribePanicTriggers(chars).listen(
          onPanic,
          onError: (Object e) {
            developer.log(
              'notify stream error on $hardwareId',
              name: 'BlePanicTrigger',
              error: e,
            );
          },
        );
    _stateSub = chars.device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        onDisconnected();
        dispose();
      }
    });
  }

  void dispose() {
    _notifySub?.cancel();
    _stateSub?.cancel();
    try {
      chars.device.disconnect();
    } catch (_) {
      // already gone
    }
  }
}

/// Riverpod provider for the BLE keychain trigger service. `keepAlive: true`
/// because the service holds long-lived BLE connections that must survive
/// across screen navigations.
@Riverpod(keepAlive: true)
BlePanicTriggerService blePanicTriggerService(Ref ref) {
  final service = BlePanicTriggerService(
    ref.watch(keychainBluetoothRepositoryProvider),
    ref.watch(keychainDeviceRepositoryProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}
