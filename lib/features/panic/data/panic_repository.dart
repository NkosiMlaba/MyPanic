/// Panic repository for backend communication.
library;

///
/// Handles sending emergency alerts to the backend and SMS to contacts.

import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
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
  /// Uses flutter_sms to send messages. Fallback to url_launcher for direct
  /// intents if needed.
  Future<bool> sendSmsToContacts({
    required List<EmergencyContact> contacts,
    required Position location,
  }) async {
    final message =
        'EMERGENCY ALERT! I need help! My location: https://maps.google.com/?q=${location.latitude},${location.longitude}';

    if (contacts.isEmpty) return false;

    // Create a list of phone numbers
    final phones = contacts.map((c) => c.phone).toList();

    // Determine separator based on platform
    // Android uses semicolon ';', iOS uses comma ',' (sometimes) or just one number
    String separator = ';';
    if (Platform.isIOS) {
      separator = ',';
    }

    final path = phones.join(separator);

    final uri = Uri(
      scheme: 'sms',
      path: path,
      queryParameters: {'body': message},
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      developer.log('Error launching SMS: $e', name: 'PanicRepository');
      return false;
    }
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
