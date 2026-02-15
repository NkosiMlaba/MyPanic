import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] State Change: ${provider.name ?? provider.runtimeType}\n'
      '   New: $newValue',
    );
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider Initialized: ${provider.name ?? provider.runtimeType}\n'
      '   Value: $value',
    );
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    debugPrint(
      '[Riverpod] Provider Failed: ${provider.name ?? provider.runtimeType}\n'
      '   Error: $error\n'
      '   Stack: $stackTrace',
    );
  }
}
