/// Abstract interface for panic trigger sources.
library;

///
/// This is the contract for the Observer Pattern that allows
/// pluggable trigger sources (manual button, BLE device, etc.)
/// without modifying core panic logic.
///
/// The [TriggerEvent] provides details about the trigger activation.

import 'dart:async';

/// Event emitted when a panic trigger is activated
class TriggerEvent {
  final DateTime timestamp;
  final TriggerSource source;
  final Map<String, dynamic>? metadata;

  TriggerEvent({required this.timestamp, required this.source, this.metadata});
}

/// Identifies the type of trigger source
enum TriggerSource { manual, ble, voice, gesture, notification, shake, qsTile }

/// Abstract interface for all panic trigger services.
///
/// Implementations:
/// - [ManualPanicTriggerService] - UI button press (Phase 1)
/// - [BlePanicTriggerService] - BLE hardware device (Phase 2)
///
/// Usage:
/// ```dart
/// final triggerService = ref.watch(activeTriggerServiceProvider);
/// triggerService.onPanicTriggered.listen((event) {
///   // Handle panic event
/// });
/// ```
abstract class PanicTriggerService {
  /// Stream that emits when a panic is triggered.
  /// Consumers should listen to this stream to react to panic events.
  Stream<TriggerEvent> get onPanicTriggered;

  /// Arms the trigger system, making it ready to detect triggers.
  /// Must be called before the system can emit panic events.
  void armSystem();

  /// Disarms the trigger system, preventing it from emitting events.
  void disarmSystem();

  /// Returns true if the system is currently armed and ready.
  bool get isArmed;

  /// Disposes of any resources used by the trigger service.
  void dispose();
}
