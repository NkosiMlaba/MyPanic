// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$manualTriggerServiceHash() =>
    r'921a44b015585085bae6549c041d294498015d68';

/// Provides the ManualPanicTriggerService instance.
/// This can be swapped for BlePanicTriggerService in Phase 2.
///
/// Copied from [manualTriggerService].
@ProviderFor(manualTriggerService)
final manualTriggerServiceProvider =
    AutoDisposeProvider<ManualPanicTriggerService>.internal(
      manualTriggerService,
      name: r'manualTriggerServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$manualTriggerServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ManualTriggerServiceRef =
    AutoDisposeProviderRef<ManualPanicTriggerService>;
String _$activeTriggerServiceHash() =>
    r'3bc766d91e7927bf2773229d2027a0190a1e800b';

/// Provides the active PanicTriggerService.
/// This abstraction allows swapping trigger implementations.
///
/// Copied from [activeTriggerService].
@ProviderFor(activeTriggerService)
final activeTriggerServiceProvider =
    AutoDisposeProvider<PanicTriggerService>.internal(
      activeTriggerService,
      name: r'activeTriggerServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activeTriggerServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveTriggerServiceRef = AutoDisposeProviderRef<PanicTriggerService>;
String _$hapticServiceHash() => r'f4cde3bb129c95bc0a12dc178c513c8bd4d3f0da';

/// Provides the HapticService.
///
/// Copied from [hapticService].
@ProviderFor(hapticService)
final hapticServiceProvider = AutoDisposeProvider<HapticService>.internal(
  hapticService,
  name: r'hapticServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hapticServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HapticServiceRef = AutoDisposeProviderRef<HapticService>;
String _$locationServiceHash() => r'38d15292e1d1d4553c8f07a36b00411aa0a8d30e';

/// Provides the LocationService.
///
/// Copied from [locationService].
@ProviderFor(locationService)
final locationServiceProvider = AutoDisposeProvider<LocationService>.internal(
  locationService,
  name: r'locationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocationServiceRef = AutoDisposeProviderRef<LocationService>;
String _$panicRepositoryHash() => r'c48fedbc011b7556146e04ac575201ade516d191';

/// Provides the PanicRepository.
///
/// Copied from [panicRepository].
@ProviderFor(panicRepository)
final panicRepositoryProvider = AutoDisposeProvider<PanicRepository>.internal(
  panicRepository,
  name: r'panicRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$panicRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PanicRepositoryRef = AutoDisposeProviderRef<PanicRepository>;
String _$panicNotifierHash() => r'd99ac4fbaad4d8e5ef4c222d2cd5362ca1efabfe';

/// Main panic state notifier.
/// Listens to trigger events and manages the panic flow.
///
/// Copied from [PanicNotifier].
@ProviderFor(PanicNotifier)
final panicNotifierProvider =
    AutoDisposeNotifierProvider<PanicNotifier, PanicState>.internal(
      PanicNotifier.new,
      name: r'panicNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$panicNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PanicNotifier = AutoDisposeNotifier<PanicState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
