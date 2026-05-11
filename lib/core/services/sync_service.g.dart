// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'647c895c03eab881e14cc07cd1493cbf6f50da76';

/// Provides a reactive stream of contacts count from the sync service.

@ProviderFor(contactsCount)
final contactsCountProvider = ContactsCountProvider._();

/// Provides a reactive stream of contacts count from the sync service.

final class ContactsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Provides a reactive stream of contacts count from the sync service.
  ContactsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactsCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return contactsCount(ref);
  }
}

String _$contactsCountHash() => r'094a39928490a69ab8618588c2c0ee28b633dc32';
