// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localDatabaseService)
final localDatabaseServiceProvider = LocalDatabaseServiceProvider._();

final class LocalDatabaseServiceProvider
    extends
        $FunctionalProvider<
          LocalDatabaseService,
          LocalDatabaseService,
          LocalDatabaseService
        >
    with $Provider<LocalDatabaseService> {
  LocalDatabaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseServiceHash();

  @$internal
  @override
  $ProviderElement<LocalDatabaseService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalDatabaseService create(Ref ref) {
    return localDatabaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabaseService>(value),
    );
  }
}

String _$localDatabaseServiceHash() =>
    r'299f3101e382ff740166017b133a0403d7e9978e';
