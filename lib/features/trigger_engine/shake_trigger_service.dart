/// Shake-based panic trigger service.
library;

///
/// Receives trigger events from the native accelerometer shake detector
/// running in the foreground service. Supports configurable sensitivity.

import 'dart:async';
import 'abstract_trigger_source.dart';
import 'native_trigger_bridge.dart';

/// Shake sensitivity levels.
///
/// Each level maps to different thresholds in the native shake algorithm:
/// - low: magnitude > 20 m/s², ≥ 5 crossings in 1s window
/// - medium: magnitude > 15 m/s², ≥ 4 crossings in 1s window
/// - high: magnitude > 12 m/s², ≥ 3 crossings in 1s window
enum ShakeSensitivity { low, medium, high }

/// Trigger service for shake-to-panic detection.
///
/// The actual shake detection runs in the native foreground service
/// (Android: SensorManager accelerometer). This Dart class manages
/// the enable/disable state and filters events from the bridge.
class ShakeTriggerService implements PanicTriggerService {
  final NativeTriggerBridge _bridge;
  final ShakeSensitivity sensitivity;
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();
  StreamSubscription<TriggerEvent>? _bridgeSubscription;
  bool _isArmed = false;

  ShakeTriggerService(this._bridge, {this.sensitivity = ShakeSensitivity.medium});

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    _isArmed = true;
    _bridgeSubscription ??= _bridge.onTriggerEvent.listen((event) {
      if (_isArmed && event.source == TriggerSource.shake) {
        _triggerController.add(event);
      }
    });
    _bridge.setShakeEnabled(enabled: true);
    _bridge.setShakeSensitivity(sensitivity.name);
  }

  @override
  void disarmSystem() {
    _isArmed = false;
    _bridge.setShakeEnabled(enabled: false);
  }

  @override
  void dispose() {
    _bridgeSubscription?.cancel();
    _bridgeSubscription = null;
    _triggerController.close();
  }
}
