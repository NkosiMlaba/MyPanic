// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keychain_device_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for [KeychainDeviceRepository]. Mirrors the
/// `panicRepository` shape in `panic_notifier.dart`.

@ProviderFor(keychainDeviceRepository)
final keychainDeviceRepositoryProvider = KeychainDeviceRepositoryProvider._();

/// Riverpod provider for [KeychainDeviceRepository]. Mirrors the
/// `panicRepository` shape in `panic_notifier.dart`.

final class KeychainDeviceRepositoryProvider
    extends
        $FunctionalProvider<
          KeychainDeviceRepository,
          KeychainDeviceRepository,
          KeychainDeviceRepository
        >
    with $Provider<KeychainDeviceRepository> {
  /// Riverpod provider for [KeychainDeviceRepository]. Mirrors the
  /// `panicRepository` shape in `panic_notifier.dart`.
  KeychainDeviceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keychainDeviceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keychainDeviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<KeychainDeviceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KeychainDeviceRepository create(Ref ref) {
    return keychainDeviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KeychainDeviceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KeychainDeviceRepository>(value),
    );
  }
}

String _$keychainDeviceRepositoryHash() =>
    r'a564434f65364265cbb506e560aa402d73f776a7';
