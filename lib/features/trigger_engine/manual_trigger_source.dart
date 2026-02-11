/// Manual panic trigger implementation.
library;

///
/// This implementation is triggered by UI button press.
/// It implements [PanicTriggerService] to emit events when
/// the user manually activates the panic button.

import 'dart:async';
import 'abstract_trigger_source.dart';

/// Manual trigger service activated by UI button press.
///
/// Usage:
/// ```dart
/// final manualTrigger = ManualPanicTriggerService();
/// manualTrigger.armSystem();
///
/// // In your UI:
/// onPressed: () => manualTrigger.triggerPanic();
/// ```
class ManualPanicTriggerService implements PanicTriggerService {
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();

  bool _isArmed = false;

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    _isArmed = true;
  }

  @override
  void disarmSystem() {
    _isArmed = false;
  }

  /// Triggers a panic event manually.
  ///
  /// This should be called when the user presses the panic button.
  /// The event will only be emitted if the system is armed.
  void triggerPanic() {
    if (!_isArmed) {
      return;
    }

    final event = TriggerEvent(
      timestamp: DateTime.now(),
      source: TriggerSource.manual,
      metadata: {'trigger_method': 'button_press'},
    );

    _triggerController.add(event);
  }

  @override
  void dispose() {
    _triggerController.close();
  }
}
