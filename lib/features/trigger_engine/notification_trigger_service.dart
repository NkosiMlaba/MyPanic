/// Notification-based panic trigger service.
library;

///
/// Receives trigger events from the persistent foreground notification's
/// PANIC action button. The notification is managed by the native
/// foreground service; this Dart class filters and forwards events.

import 'dart:async';
import 'abstract_trigger_source.dart';
import 'native_trigger_bridge.dart';

/// Trigger service for the persistent notification PANIC button.
///
/// Works when the app is in foreground, background, or killed (the native
/// foreground service keeps the notification alive independently).
class NotificationTriggerService implements PanicTriggerService {
  final NativeTriggerBridge _bridge;
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();
  StreamSubscription<TriggerEvent>? _bridgeSubscription;
  bool _isArmed = false;

  NotificationTriggerService(this._bridge);

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    _isArmed = true;
    _bridgeSubscription ??= _bridge.onTriggerEvent.listen((event) {
      if (_isArmed && event.source == TriggerSource.notification) {
        _triggerController.add(event);
      }
    });
    _bridge.startForegroundService();
    _bridge.updateNotificationState(armed: true);
  }

  @override
  void disarmSystem() {
    _isArmed = false;
    _bridge.updateNotificationState(armed: false);
  }

  @override
  void dispose() {
    _bridgeSubscription?.cancel();
    _bridgeSubscription = null;
    _triggerController.close();
  }
}
