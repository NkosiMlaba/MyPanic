/// Platform channel bridge for native trigger sources.
library;

///
/// Manages MethodChannel (Dart → Native) and EventChannel (Native → Dart)
/// for foreground service, shake detection, and Quick Settings tile.

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'abstract_trigger_source.dart';

/// Dart-side bridge to native trigger engine (Android/iOS).
///
/// All native trigger features share a single MethodChannel and EventChannel.
/// Native events arrive as maps and are converted to [TriggerEvent] objects.
class NativeTriggerBridge {
  static const _methodChannel =
      MethodChannel('com.enectus.my_panic/trigger_engine');
  static const _eventChannel =
      EventChannel('com.enectus.my_panic/trigger_events');

  StreamSubscription<dynamic>? _eventSubscription;
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();

  /// Stream of trigger events from native code.
  Stream<TriggerEvent> get onTriggerEvent => _triggerController.stream;

  /// Start listening to native events.
  void initialize() {
    _eventSubscription ??= _eventChannel
        .receiveBroadcastStream()
        .listen(_handleNativeEvent, onError: _handleError);
  }

  void _handleNativeEvent(dynamic event) {
    if (event is! Map) return;

    final sourceStr = event['source'] as String?;
    final timestamp = event['timestamp'] as int?;
    final metadata = event['metadata'] as Map<String, dynamic>?;

    final source = _parseSource(sourceStr);
    if (source == null) return;

    _triggerController.add(TriggerEvent(
      timestamp: timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : DateTime.now(),
      source: source,
      metadata: metadata,
    ));
  }

  TriggerSource? _parseSource(String? source) {
    return switch (source) {
      'notification' => TriggerSource.notification,
      'shake' => TriggerSource.shake,
      'qs_tile' => TriggerSource.qsTile,
      _ => null,
    };
  }

  void _handleError(Object error) {
    // EventChannel errors are non-fatal — the channel will be re-established
    // on next listen. Log but don't crash.
  }

  // ── MethodChannel calls (Dart → Native) ─────────────────────────────────

  /// Start the foreground service with persistent notification.
  Future<void> startForegroundService() async {
    if (!Platform.isAndroid) return;
    await _methodChannel.invokeMethod('startForegroundService');
  }

  /// Stop the foreground service.
  Future<void> stopForegroundService() async {
    if (!Platform.isAndroid) return;
    await _methodChannel.invokeMethod('stopForegroundService');
  }

  /// Update the notification to reflect armed/disarmed state.
  Future<void> updateNotificationState({required bool armed}) async {
    if (!Platform.isAndroid) return;
    await _methodChannel
        .invokeMethod('updateNotificationState', {'armed': armed});
  }

  /// Enable or disable shake detection in the foreground service.
  Future<void> setShakeEnabled({required bool enabled}) async {
    if (!Platform.isAndroid) return;
    await _methodChannel.invokeMethod('setShakeEnabled', {'enabled': enabled});
  }

  /// Set shake sensitivity level.
  Future<void> setShakeSensitivity(String level) async {
    if (!Platform.isAndroid) return;
    await _methodChannel
        .invokeMethod('setShakeSensitivity', {'level': level});
  }

  /// Update the Quick Settings tile state.
  Future<void> updateQSTileState({
    required bool armed,
    required bool loggedIn,
  }) async {
    if (!Platform.isAndroid) return;
    await _methodChannel.invokeMethod(
        'updateQSTileState', {'armed': armed, 'loggedIn': loggedIn});
  }

  /// Check if the foreground service is currently running.
  Future<bool> isForegroundServiceRunning() async {
    if (!Platform.isAndroid) return false;
    final result =
        await _methodChannel.invokeMethod<bool>('isForegroundServiceRunning');
    return result ?? false;
  }

  /// Clean up resources.
  void dispose() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
    _triggerController.close();
  }
}
