import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';

/// Provides the current user's medical profile.
///
/// In a real app, this would fetch from a database or API.
/// For MVP, we return a dummy profile.
final medicalProfileProvider = Provider<MedicalProfile>((ref) {
  return const MedicalProfile(
    bloodType: 'O+',
    allergies: ['Peanuts', 'Penicillin'],
    medications: ['None'],
    conditions: ['Asthma'],
    emergencyNotes: 'Carry inhaler at all times.',
    doctorName: 'Dr. Smith',
    doctorPhone: '+27123456789',
  );
});
