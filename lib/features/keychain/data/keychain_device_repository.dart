/// Repository for the keychain pairing + management endpoints.
///
/// Wraps the three JWT-authenticated routes on the device-management
/// surface introduced in Section A of the ESP32 keychain plan:
///   POST   /api/v1/devices/pair
///   GET    /api/v1/devices
///   DELETE /api/v1/devices/{id}
///
/// The device-panic endpoint itself (`POST /api/v1/devices/{hardwareId}/panic`)
/// is NOT here — that's authenticated by the device's plaintext secret, not
/// the user's JWT, and it's called by the firmware over WiFi-fallback, not by
/// this app.
library;

import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'keychain_device_repository.g.dart';

class KeychainDeviceRepository {
  final MyPanicApiClient _api;

  KeychainDeviceRepository(this._api);

  /// Pairs a new panic keychain to the calling user. The server generates a
  /// random 32-byte secret, hashes it with bcrypt, and stores only the hash;
  /// the returned [PairedDevice.deviceSecret] is the plaintext, returned
  /// exactly once. Callers MUST immediately BLE-push the secret to the
  /// keychain and not persist it locally.
  Future<PairedDevice> pairDevice({
    required String hardwareId,
    required String displayName,
  }) async {
    final json = await _api.post(
      '/api/v1/devices/pair',
      {
        'hardwareId': hardwareId,
        'displayName': displayName,
      },
    ) as Map<String, dynamic>;
    return PairedDevice.fromJson(json);
  }

  /// Lists all paired keychains belonging to the calling user. Does not
  /// expose any secret material; only `id`, `hardwareId`, `displayName`,
  /// `pairedAt`, and `lastSeenAt` are returned.
  Future<List<DeviceSummary>> listDevices() async {
    final raw = await _api.get('/api/v1/devices') as List<dynamic>;
    return raw
        .map((e) => DeviceSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Revokes a previously-paired keychain. The server marks the row as
  /// revoked (sets `revoked_at`) — subsequent panic POSTs from that device
  /// secret return 401. Idempotent on the server side.
  Future<void> revokeDevice(String deviceId) =>
      _api.delete('/api/v1/devices/$deviceId');
}

/// Returned by [KeychainDeviceRepository.pairDevice] exactly once. The
/// [deviceSecret] is the plaintext shared secret; it is the ONLY time the
/// app sees it. BLE-push it to the keychain and drop it from memory.
class PairedDevice {
  final String id;
  final String hardwareId;
  final String deviceSecret;
  final String displayName;
  final DateTime pairedAt;

  const PairedDevice({
    required this.id,
    required this.hardwareId,
    required this.deviceSecret,
    required this.displayName,
    required this.pairedAt,
  });

  factory PairedDevice.fromJson(Map<String, dynamic> json) => PairedDevice(
        id: json['id'] as String,
        hardwareId: json['hardwareId'] as String,
        deviceSecret: json['deviceSecret'] as String,
        displayName: json['displayName'] as String,
        pairedAt: DateTime.parse(json['pairedAt'] as String),
      );
}

/// Server projection of a paired device for listing. Intentionally omits
/// the secret (and even the hash).
class DeviceSummary {
  final String id;
  final String hardwareId;
  final String displayName;
  final DateTime pairedAt;
  final DateTime? lastSeenAt;

  const DeviceSummary({
    required this.id,
    required this.hardwareId,
    required this.displayName,
    required this.pairedAt,
    this.lastSeenAt,
  });

  factory DeviceSummary.fromJson(Map<String, dynamic> json) => DeviceSummary(
        id: json['id'] as String,
        hardwareId: json['hardwareId'] as String,
        displayName: json['displayName'] as String,
        pairedAt: DateTime.parse(json['pairedAt'] as String),
        lastSeenAt: json['lastSeenAt'] == null
            ? null
            : DateTime.parse(json['lastSeenAt'] as String),
      );
}

/// Riverpod provider for [KeychainDeviceRepository]. Mirrors the
/// `panicRepository` shape in `panic_notifier.dart`.
@riverpod
KeychainDeviceRepository keychainDeviceRepository(Ref ref) {
  return KeychainDeviceRepository(ref.watch(myPanicApiClientProvider));
}
