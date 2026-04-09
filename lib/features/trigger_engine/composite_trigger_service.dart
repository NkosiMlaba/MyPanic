/// Composite trigger service that merges multiple trigger sources.
library;

///
/// Aggregates multiple [PanicTriggerService] implementations into a single
/// stream, allowing the app to listen for panic events from any source
/// (manual button, notification, shake, QS tile, BLE, etc.)

import 'dart:async';
import 'abstract_trigger_source.dart';

/// Merges multiple [PanicTriggerService] streams into one.
///
/// The [PanicNotifier] watches a single [PanicTriggerService] via
/// `activeTriggerServiceProvider`. This class makes it possible to have
/// multiple active trigger sources without changing the notifier.
class CompositeTriggerService implements PanicTriggerService {
  final List<PanicTriggerService> _sources;
  final StreamController<TriggerEvent> _mergedController =
      StreamController<TriggerEvent>.broadcast();
  final List<StreamSubscription<TriggerEvent>> _subscriptions = [];
  bool _isArmed = false;

  CompositeTriggerService(this._sources) {
    for (final source in _sources) {
      final sub = source.onPanicTriggered.listen((event) {
        if (_isArmed) {
          _mergedController.add(event);
        }
      });
      _subscriptions.add(sub);
    }
  }

  @override
  Stream<TriggerEvent> get onPanicTriggered => _mergedController.stream;

  @override
  bool get isArmed => _isArmed;

  @override
  void armSystem() {
    _isArmed = true;
    for (final source in _sources) {
      source.armSystem();
    }
  }

  @override
  void disarmSystem() {
    _isArmed = false;
    for (final source in _sources) {
      source.disarmSystem();
    }
  }

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
    for (final source in _sources) {
      source.dispose();
    }
    _mergedController.close();
  }
}
