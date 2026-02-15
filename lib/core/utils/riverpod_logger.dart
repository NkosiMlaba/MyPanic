import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log(
      'State Change: ${provider.name ?? provider.runtimeType}',
      name: 'Riverpod',
      error: 'New: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    log(
      'Provider Initialized: ${provider.name ?? provider.runtimeType}',
      name: 'Riverpod',
      error: 'Value: $value',
    );
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log(
      'Provider Failed: ${provider.name ?? provider.runtimeType}',
      name: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
