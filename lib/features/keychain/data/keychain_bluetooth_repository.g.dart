// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keychain_bluetooth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(keychainBluetoothRepository)
final keychainBluetoothRepositoryProvider =
    KeychainBluetoothRepositoryProvider._();

final class KeychainBluetoothRepositoryProvider
    extends
        $FunctionalProvider<
          KeychainBluetoothRepository,
          KeychainBluetoothRepository,
          KeychainBluetoothRepository
        >
    with $Provider<KeychainBluetoothRepository> {
  KeychainBluetoothRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keychainBluetoothRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keychainBluetoothRepositoryHash();

  @$internal
  @override
  $ProviderElement<KeychainBluetoothRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeychainBluetoothRepository create(Ref ref) {
    return keychainBluetoothRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeychainBluetoothRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeychainBluetoothRepository>(value),
    );
  }
}

String _$keychainBluetoothRepositoryHash() =>
    r'57013b3ff2bb192b75043ceffa0a9f122fc84a26';
