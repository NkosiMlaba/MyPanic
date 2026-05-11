// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_panic_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(myPanicApiClient)
final myPanicApiClientProvider = MyPanicApiClientProvider._();

final class MyPanicApiClientProvider
    extends
        $FunctionalProvider<
          MyPanicApiClient,
          MyPanicApiClient,
          MyPanicApiClient
        >
    with $Provider<MyPanicApiClient> {
  MyPanicApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myPanicApiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myPanicApiClientHash();

  @$internal
  @override
  $ProviderElement<MyPanicApiClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MyPanicApiClient create(Ref ref) {
    return myPanicApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MyPanicApiClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MyPanicApiClient>(value),
    );
  }
}

String _$myPanicApiClientHash() => r'b4ec44a0f36d26bbfacaed560990e6b51b46ab9d';
