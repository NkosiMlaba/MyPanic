/// Panic repository — REST-backed against MyPanic.Api.
library;

/// Sends emergency alerts to /api/v1/alerts and cancels them via
/// /api/v1/alerts/{id}/cancel. The backend owns SMS fan-out via SMSFlow, so
/// `sendSmsToContacts` is intentionally gone — the panic flow now hands the
/// alert to the server and the server dispatches per-recipient jobs through
/// FanOutAlertJob.

import 'dart:developer' as developer;

import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/features/panic/domain/entities/alert_status.dart';

class PanicRepository {
  final MyPanicApiClient _api;

  PanicRepository(this._api);

  /// Posts a panic alert. Returns 202-derived [AlertStatus] (the API responds
  /// fast and dispatches SMS asynchronously — recipient list is not known at
  /// this point, so [AlertStatus.notifiedContacts] stays empty). Throws
  /// [ApiException] on non-2xx; caller maps that to a user-visible error.
  Future<AlertStatus> sendEmergencyAlert({
    required Position location,
    required DateTime triggeredAt,
  }) async {
    final clientIdempotencyKey = const Uuid().v4();
    final body = {
      'latitude': location.latitude,
      'longitude': location.longitude,
      // geolocator's accuracy is meters; null is fine if the platform didn't
      // report it.
      'locationAccuracyM':
          location.accuracy.isFinite ? location.accuracy : null,
      'triggeredAt': triggeredAt.toUtc().toIso8601String(),
      'clientIdempotencyKey': clientIdempotencyKey,
    };

    final json = await _api.post('/api/v1/alerts', body) as Map<String, dynamic>;
    return AlertStatus(
      alertId: json['alertId'] as String,
      createdAt: _parseDate(json['triggeredAt']) ?? DateTime.now().toUtc(),
      state: _stateFromApi(json['status'] as String?),
      latitude: location.latitude,
      longitude: location.longitude,
    );
  }

  /// Cancels an in-flight alert. The server flips status to Cancelled; per
  /// AlertsController, per-recipient SMS already enqueued may still send (race
  /// is documented server-side). Returns true if the API accepted the cancel.
  Future<bool> cancelAlert(String alertId) async {
    try {
      await _api.post('/api/v1/alerts/$alertId/cancel', null);
      return true;
    } on ApiException catch (e) {
      developer.log(
        'cancelAlert($alertId) failed',
        name: 'PanicRepository',
        error: e,
      );
      return false;
    }
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  static DateTime? _parseDate(Object? raw) =>
      raw is String ? DateTime.tryParse(raw) : null;

  /// Map the API's status string ("Pending", "Sending", "Sent", ...) onto
  /// [AlertState]. The 202 response from POST /alerts is almost always
  /// "Pending" — the client polls GET /alerts/{id} for terminal status.
  static AlertState _stateFromApi(String? status) {
    switch (status?.toLowerCase()) {
      case 'sending':
        return AlertState.sending;
      case 'sent':
        return AlertState.sent;
      case 'acknowledged':
        return AlertState.acknowledged;
      case 'resolved':
        return AlertState.resolved;
      case 'failed':
        return AlertState.failed;
      case 'cancelled':
        // No dedicated AlertState.cancelled in the Flutter enum yet; treat as
        // failed so UI clears the "active" state.
        return AlertState.failed;
      case 'pending':
      default:
        return AlertState.pending;
    }
  }
}
