// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ble_panic_trigger_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for the BLE keychain trigger service. `keepAlive: true`
/// because the service holds long-lived BLE connections that must survive
/// across screen navigations.

@ProviderFor(blePanicTriggerService)
final blePanicTriggerServiceProvider = BlePanicTriggerServiceProvider._();

/// Riverpod provider for the BLE keychain trigger service. `keepAlive: true`
/// because the service holds long-lived BLE connections that must survive
/// across screen navigations.

final class BlePanicTriggerServiceProvider
    extends
        $FunctionalProvider<
          BlePanicTriggerService,
          BlePanicTriggerService,
          BlePanicTriggerService
        >
    with $Provider<BlePanicTriggerService> {
  /// Riverpod provider for the BLE keychain trigger service. `keepAlive: true`
  /// because the service holds long-lived BLE connections that must survive
  /// across screen navigations.
  BlePanicTriggerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'blePanicTriggerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$blePanicTriggerServiceHash();

  @$internal
  @override
  $ProviderElement<BlePanicTriggerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BlePanicTriggerService create(Ref ref) {
    return blePanicTriggerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BlePanicTriggerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BlePanicTriggerService>(value),
    );
  }
}

String _$blePanicTriggerServiceHash() =>
    r'267b26bd639eb5dbcd5ebf4c878888a57b5f9a28';
