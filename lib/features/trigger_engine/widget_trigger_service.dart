/// Home screen widget panic trigger service (Android only).
library;

///
/// Receives trigger events from Android home screen widgets.
/// Widgets are always available once added by the user, so this service
/// is always included in the composite trigger when on Android.

import 'dart:async';
import 'dart:io' show Platform;
import 'abstract_trigger_source.dart';
import 'native_trigger_bridge.dart';

/// Trigger service for home screen panic widgets.
///
/// Three widget variants (1x1 button, 2x1 quick, 4x1 status) all route
/// through [PanicActionReceiver] with source="widget", arriving here
/// via the shared EventChannel.
class WidgetTriggerService implements PanicTriggerService {
  final NativeTriggerBridge _bridge;
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();
  StreamSubscription<TriggerEvent>? _bridgeSubscription;
  bool _isArmed = false;

  WidgetTriggerService(this._bridge);

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    if (!Platform.isAndroid) return;
    _isArmed = true;
    _bridgeSubscription ??= _bridge.onTriggerEvent.listen((event) {
      if (_isArmed && event.source == TriggerSource.widget) {
        _triggerController.add(event);
      }
    });
  }

  @override
  void disarmSystem() {
    _isArmed = false;
  }

  @override
  void dispose() {
    _bridgeSubscription?.cancel();
    _bridgeSubscription = null;
    _triggerController.close();
  }
}
