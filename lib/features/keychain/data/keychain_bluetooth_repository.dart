import 'dart:async';
import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:my_panic/features/keychain/data/keychain_bluetooth_uuids.dart';

part 'keychain_bluetooth_repository.g.dart';

/// Thin facade around flutter_blue_plus for the keychain use case. Owns
/// the BLE central role; does not know about the API or Riverpod state.
class KeychainBluetoothRepository {
  /// Start a BLE scan and stream the latest list of seen MyPanic devices.
  /// Auto-stops after [timeout].
  Stream<List<ScanResult>> scan({
    Duration timeout = const Duration(seconds: 10),
  }) async* {
    await FlutterBluePlus.startScan(
      withServices: [Guid(KeychainUuids.service)],
      timeout: timeout,
    );
    yield* FlutterBluePlus.scanResults;
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  /// Connect, discover services, return a handle to the four MyPanic
  /// characteristics. Throws [StateError] if the device doesn't expose them.
  Future<KeychainCharacteristics> connect(BluetoothDevice device) async {
    await device.connect(timeout: const Duration(seconds: 8));
    final services = await device.discoverServices();
    final svc = services.firstWhere(
      (s) => s.uuid == Guid(KeychainUuids.service),
      orElse: () => throw StateError('MyPanic service not found on device'),
    );

    BluetoothCharacteristic? hwId;
    BluetoothCharacteristic? pairData;
    BluetoothCharacteristic? trigger;
    BluetoothCharacteristic? ack;

    for (final c in svc.characteristics) {
      if (c.uuid == Guid(KeychainUuids.hardwareId)) hwId = c;
      if (c.uuid == Guid(KeychainUuids.pairData)) pairData = c;
      if (c.uuid == Guid(KeychainUuids.panicTrigger)) trigger = c;
      if (c.uuid == Guid(KeychainUuids.panicAck)) ack = c;
    }

    if (hwId == null || pairData == null || trigger == null || ack == null) {
      throw StateError('MyPanic characteristics incomplete on device');
    }
    return KeychainCharacteristics(
      device: device,
      hardwareId: hwId,
      pairData: pairData,
      trigger: trigger,
      ack: ack,
    );
  }

  /// Reads the hardware id off the connected characteristic.
  Future<String> readHardwareId(KeychainCharacteristics chars) async {
    final bytes = await chars.hardwareId.read();
    return utf8.decode(bytes);
  }

  /// Writes the JSON pair-data blob. Throws on BLE error.
  Future<void> writePairData(
    KeychainCharacteristics chars, {
    required String deviceSecret,
    required String wifiSsid,
    required String wifiPass,
  }) async {
    final payload = jsonEncode({
      'secret': deviceSecret,
      'wifi_ssid': wifiSsid,
      'wifi_pass': wifiPass,
    });
    await chars.pairData.write(
      utf8.encode(payload),
      withoutResponse: false,
    );
  }

  /// Subscribe to panic-trigger notifications. Stream emits the raw JSON
  /// string the firmware notifies (caller parses).
  Stream<String> subscribePanicTriggers(KeychainCharacteristics chars) async* {
    await chars.trigger.setNotifyValue(true);
    yield* chars.trigger.lastValueStream
        .where((bytes) => bytes.isNotEmpty)
        .map(utf8.decode);
  }

  /// Writes the ack payload — "ack" if the phone is handling the panic;
  /// "cancel" if the user cancelled from the app.
  Future<void> sendAck(KeychainCharacteristics chars,
      {bool cancelled = false}) async {
    final payload = cancelled ? 'cancel' : 'ack';
    await chars.ack.write(utf8.encode(payload), withoutResponse: false);
  }
}

/// Public handle to a connected keychain's characteristics + device. Used by
/// the pairing screen and the background listener. The pairing screen
/// disposes via `device.disconnect()` once write completes.
class KeychainCharacteristics {
  final BluetoothDevice device;
  final BluetoothCharacteristic hardwareId;
  final BluetoothCharacteristic pairData;
  final BluetoothCharacteristic trigger;
  final BluetoothCharacteristic ack;

  KeychainCharacteristics({
    required this.device,
    required this.hardwareId,
    required this.pairData,
    required this.trigger,
    required this.ack,
  });
}

@Riverpod(keepAlive: true)
KeychainBluetoothRepository keychainBluetoothRepository(Ref ref) {
  return KeychainBluetoothRepository();
}
