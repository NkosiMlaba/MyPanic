/// Panic repository for backend communication.
///
/// Handles sending emergency alerts to the backend and SMS to contacts.

import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/panic/domain/entities/alert_status.dart';

/// Repository for panic-related backend operations.
class PanicRepository {
  /// Sends an emergency alert to the backend.
  ///
  /// In MVP, this logs the action. In production, this would make an API call.
  Future<AlertStatus> sendEmergencyAlert({
    required Position location,
    required MedicalProfile profile,
    required List<EmergencyContact> contacts,
  }) async {
    final alertId = DateTime.now().millisecondsSinceEpoch.toString();

    developer.log(
      'EMERGENCY ALERT SENT',
      name: 'PanicRepository',
      error: {
        'alertId': alertId,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'contactsCount': contacts.length,
        'bloodType': profile.bloodType,
        'allergies': profile.allergies,
        'conditions': profile.conditions,
      },
    );

    // TODO: In production, make actual API call:
    // final response = await _apiClient.post('/api/alerts', body: {
    //   'location': {'lat': location.latitude, 'lng': location.longitude},
    //   'profile': profile.toJson(),
    //   'contacts': contacts.map((c) => c.toJson()).toList(),
    // });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return AlertStatus(
      alertId: alertId,
      createdAt: DateTime.now(),
      state: AlertState.sent,
      latitude: location.latitude,
      longitude: location.longitude,
      notifiedContacts: contacts.map((c) => c.phone).toList(),
    );
  }

  /// Sends SMS to emergency contacts.
  ///
  /// In MVP, this logs the action. In production, this would use flutter_sms
  /// or platform-specific SMS intents.
  Future<bool> sendSmsToContacts({
    required List<EmergencyContact> contacts,
    required Position location,
  }) async {
    final message = '''
EMERGENCY ALERT!
I need help! This is an automated emergency message.
My location: https://maps.google.com/?q=${location.latitude},${location.longitude}
Please contact local emergency services if needed.
''';

    for (final contact in contacts) {
      developer.log(
        'SMS SENT (SIMULATED)',
        name: 'PanicRepository',
        error: {
          'to': contact.phone,
          'name': contact.name,
          'message': message,
        },
      );
    }

    // TODO: In production, use flutter_sms or platform intents:
    // await sendSMS(
    //   message: message,
    //   recipients: contacts.map((c) => c.phone).toList(),
    // );

    return true;
  }

  /// Cancels an active alert.
  Future<bool> cancelAlert(String alertId) async {
    developer.log(
      'ALERT CANCELLED',
      name: 'PanicRepository',
      error: {'alertId': alertId},
    );

    // TODO: Notify backend that alert was cancelled
    // await _apiClient.post('/api/alerts/$alertId/cancel');

    return true;
  }
}
