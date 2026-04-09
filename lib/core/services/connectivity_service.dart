/// Network connectivity monitoring service.
library;

///
/// Wraps `connectivity_plus` to provide a simple, reactive interface for
/// checking network availability. Used by the sync service to decide
/// whether to attempt Firestore operations or fall back to local cache.

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connectivity_service.g.dart';

@riverpod
ConnectivityService connectivityService(Ref ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Streams the current network connectivity status.
@riverpod
Stream<bool> isOnline(Ref ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.onConnectivityChanged;
}

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();

  bool _lastKnownState = true;

  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    // Check initial state
    _checkInitial();
  }

  /// Stream that emits true/false when connectivity changes.
  Stream<bool> get onConnectivityChanged => _controller.stream;

  /// Current known connectivity state.
  bool get isConnected => _lastKnownState;

  /// Check connectivity right now (one-shot).
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    final connected = _isConnected(results);
    _lastKnownState = connected;
    return connected;
  }

  void _onChanged(List<ConnectivityResult> results) {
    final connected = _isConnected(results);
    if (connected != _lastKnownState) {
      _lastKnownState = connected;
      _controller.add(connected);
    }
  }

  Future<void> _checkInitial() async {
    final connected = await checkConnectivity();
    _controller.add(connected);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.ethernet);
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
