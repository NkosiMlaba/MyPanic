/// Medical profile entity.
library;

///
/// Contains medical information to be shared during emergencies.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_profile.freezed.dart';
part 'medical_profile.g.dart';

/// Medical profile information for emergency situations.
@freezed
class MedicalProfile with _$MedicalProfile {
  const factory MedicalProfile({
    String? bloodType,
    @Default([]) List<String> allergies,
    @Default([]) List<String> medications,
    @Default([]) List<String> conditions,
    String? emergencyNotes,
    String? insuranceInfo,
    String? doctorName,
    String? doctorPhone,
  }) = _MedicalProfile;

  factory MedicalProfile.fromJson(Map<String, dynamic> json) =>
      _$MedicalProfileFromJson(json);
}
