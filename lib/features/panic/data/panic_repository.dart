/// Panic repository for backend communication.
///
/// Handles sending emergency alerts to the backend and SMS to contacts.

import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:url_launcher/url_launcher.dart';
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

    final recipients = contacts.map((c) => c.phone).toList();

    try {
      // Try using flutter_sms
      // On some devices/platforms this might fail or open a dialog
      await sendSMS(
        message: message,
        recipients: recipients,
        sendDirect: false,
      ).catchError((onError) {
        developer.log('Flutter SMS failed: $onError', name: 'PanicRepository');
        throw onError; // Rethrow to trigger fallback
      });
      return true;
    } catch (e) {
      developer.log(
        'Falling back to generic SMS intent',
        name: 'PanicRepository',
      );
      // Fallback: Try opening SMS app with details
      // This usually only supports one recipient or specific format depending on platform
      // We'll try the first contact as a fallback
      if (contacts.isNotEmpty) {
        final uri = Uri(
          scheme: 'sms',
          path: contacts.first.phone,
          queryParameters: {'body': message},
        );
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return true;
        }
      }
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
