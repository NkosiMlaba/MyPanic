/// Quick Settings tile panic trigger service (Android only).
library;

///
/// Receives trigger events from the Android Quick Settings tile.
/// On iOS this service is a no-op (QS tiles don't exist).

import 'dart:async';
import 'dart:io' show Platform;
import 'abstract_trigger_source.dart';
import 'native_trigger_bridge.dart';

/// Trigger service for the Android Quick Settings tile.
///
/// The tile is implemented natively as a [TileService] in Kotlin.
/// This Dart class manages state synchronization and filters events.
/// On iOS, all methods are no-ops.
class QSTileTriggerService implements PanicTriggerService {
  final NativeTriggerBridge _bridge;
  final StreamController<TriggerEvent> _triggerController =
      StreamController<TriggerEvent>.broadcast();
  StreamSubscription<TriggerEvent>? _bridgeSubscription;
  bool _isArmed = false;

  QSTileTriggerService(this._bridge);

  @override
  Stream<TriggerEvent> get onPanicTriggered => _triggerController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    if (!Platform.isAndroid) return;
    _isArmed = true;
    _bridgeSubscription ??= _bridge.onTriggerEvent.listen((event) {
      if (_isArmed && event.source == TriggerSource.qsTile) {
        _triggerController.add(event);
      }
    });
    _bridge.updateQSTileState(armed: true, loggedIn: true);
  }

  @override
  void disarmSystem() {
    if (!Platform.isAndroid) return;
    _isArmed = false;
    _bridge.updateQSTileState(armed: false, loggedIn: true);
  }

  @override
  void dispose() {
    _bridgeSubscription?.cancel();
    _bridgeSubscription = null;
    _triggerController.close();
  }
}
