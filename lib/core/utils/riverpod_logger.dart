import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class RiverpodLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    debugPrint(
      '[Riverpod] State Change: ${context.provider.name ?? context.provider.runtimeType}\n'
      '   New: $newValue',
    );
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    debugPrint(
      '[Riverpod] Provider Initialized: ${context.provider.name ?? context.provider.runtimeType}\n'
      '   Value: $value',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      '[Riverpod] Provider Failed: ${context.provider.name ?? context.provider.runtimeType}\n'
      '   Error: $error\n'
      '   Stack: $stackTrace',
    );
  }
}
