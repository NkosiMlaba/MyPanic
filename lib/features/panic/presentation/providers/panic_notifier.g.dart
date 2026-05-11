// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panic_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the ManualPanicTriggerService instance.
/// This can be swapped for BlePanicTriggerService in Phase 2.

@ProviderFor(manualTriggerService)
final manualTriggerServiceProvider = ManualTriggerServiceProvider._();

/// Provides the ManualPanicTriggerService instance.
/// This can be swapped for BlePanicTriggerService in Phase 2.

final class ManualTriggerServiceProvider
    extends
        $FunctionalProvider<
          ManualPanicTriggerService,
          ManualPanicTriggerService,
          ManualPanicTriggerService
        >
    with $Provider<ManualPanicTriggerService> {
  /// Provides the ManualPanicTriggerService instance.
  /// This can be swapped for BlePanicTriggerService in Phase 2.
  ManualTriggerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'manualTriggerServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$manualTriggerServiceHash();

  @$internal
  @override
  $ProviderElement<ManualPanicTriggerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ManualPanicTriggerService create(Ref ref) {
    return manualTriggerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManualPanicTriggerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManualPanicTriggerService>(value),
    );
  }
}

String _$manualTriggerServiceHash() =>
    r'921a44b015585085bae6549c041d294498015d68';

/// Provides the NativeTriggerBridge singleton.

@ProviderFor(nativeTriggerBridge)
final nativeTriggerBridgeProvider = NativeTriggerBridgeProvider._();

/// Provides the NativeTriggerBridge singleton.

final class NativeTriggerBridgeProvider
    extends
        $FunctionalProvider<
          NativeTriggerBridge,
          NativeTriggerBridge,
          NativeTriggerBridge
        >
    with $Provider<NativeTriggerBridge> {
  /// Provides the NativeTriggerBridge singleton.
  NativeTriggerBridgeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nativeTriggerBridgeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nativeTriggerBridgeHash();

  @$internal
  @override
  $ProviderElement<NativeTriggerBridge> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NativeTriggerBridge create(Ref ref) {
    return nativeTriggerBridge(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NativeTriggerBridge value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NativeTriggerBridge>(value),
    );
  }
}

String _$nativeTriggerBridgeHash() =>
    r'5823d38a6e268a06a204787a21d203980c7a268b';

/// Provides the active PanicTriggerService.
///
/// Builds a [CompositeTriggerService] that merges the manual trigger with
/// any enabled native triggers (notification, shake, QS tile).

@ProviderFor(activeTriggerService)
final activeTriggerServiceProvider = ActiveTriggerServiceProvider._();

/// Provides the active PanicTriggerService.
///
/// Builds a [CompositeTriggerService] that merges the manual trigger with
/// any enabled native triggers (notification, shake, QS tile).

final class ActiveTriggerServiceProvider
    extends
        $FunctionalProvider<
          PanicTriggerService,
          PanicTriggerService,
          PanicTriggerService
        >
    with $Provider<PanicTriggerService> {
  /// Provides the active PanicTriggerService.
  ///
  /// Builds a [CompositeTriggerService] that merges the manual trigger with
  /// any enabled native triggers (notification, shake, QS tile).
  ActiveTriggerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTriggerServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTriggerServiceHash();

  @$internal
  @override
  $ProviderElement<PanicTriggerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PanicTriggerService create(Ref ref) {
    return activeTriggerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanicTriggerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanicTriggerService>(value),
    );
  }
}

String _$activeTriggerServiceHash() =>
    r'8616c2d037c5d0b65d7bd70709d3bf9122e8e664';

/// Provides the HapticService.

@ProviderFor(hapticService)
final hapticServiceProvider = HapticServiceProvider._();

/// Provides the HapticService.

final class HapticServiceProvider
    extends $FunctionalProvider<HapticService, HapticService, HapticService>
    with $Provider<HapticService> {
  /// Provides the HapticService.
  HapticServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hapticServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hapticServiceHash();

  @$internal
  @override
  $ProviderElement<HapticService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HapticService create(Ref ref) {
    return hapticService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HapticService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HapticService>(value),
    );
  }
}

String _$hapticServiceHash() => r'f4cde3bb129c95bc0a12dc178c513c8bd4d3f0da';

/// Provides the LocationService.

@ProviderFor(locationService)
final locationServiceProvider = LocationServiceProvider._();

/// Provides the LocationService.

final class LocationServiceProvider
    extends
        $FunctionalProvider<LocationService, LocationService, LocationService>
    with $Provider<LocationService> {
  /// Provides the LocationService.
  LocationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationServiceHash();

  @$internal
  @override
  $ProviderElement<LocationService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocationService create(Ref ref) {
    return locationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationService>(value),
    );
  }
}

String _$locationServiceHash() => r'38d15292e1d1d4553c8f07a36b00411aa0a8d30e';

/// Provides the PanicRepository, wired to the typed MyPanic API client.

@ProviderFor(panicRepository)
final panicRepositoryProvider = PanicRepositoryProvider._();

/// Provides the PanicRepository, wired to the typed MyPanic API client.

final class PanicRepositoryProvider
    extends
        $FunctionalProvider<PanicRepository, PanicRepository, PanicRepository>
    with $Provider<PanicRepository> {
  /// Provides the PanicRepository, wired to the typed MyPanic API client.
  PanicRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panicRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panicRepositoryHash();

  @$internal
  @override
  $ProviderElement<PanicRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PanicRepository create(Ref ref) {
    return panicRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanicRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanicRepository>(value),
    );
  }
}

String _$panicRepositoryHash() => r'385ec676b19b2ed54ebccb7ed5ce692c022732b2';

/// Main panic state notifier.
/// Listens to trigger events and manages the panic flow.

@ProviderFor(PanicNotifier)
final panicProvider = PanicNotifierProvider._();

/// Main panic state notifier.
/// Listens to trigger events and manages the panic flow.
final class PanicNotifierProvider
    extends $NotifierProvider<PanicNotifier, PanicState> {
  /// Main panic state notifier.
  /// Listens to trigger events and manages the panic flow.
  PanicNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'panicProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$panicNotifierHash();

  @$internal
  @override
  PanicNotifier create() => PanicNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PanicState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PanicState>(value),
    );
  }
}

String _$panicNotifierHash() => r'20dbb7e28c9833da473027ec48524b197b7bf7c7';

/// Main panic state notifier.
/// Listens to trigger events and manages the panic flow.

abstract class _$PanicNotifier extends $Notifier<PanicState> {
  PanicState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PanicState, PanicState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PanicState, PanicState>,
              PanicState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
