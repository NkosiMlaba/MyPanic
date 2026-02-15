/// Medical profile entity.
library;

///
/// Contains medical information to be shared during emergencies.

import 'package:json_annotation/json_annotation.dart';

part 'medical_profile.g.dart';

/// Medical profile information for emergency situations.
@JsonSerializable(explicitToJson: true)
class MedicalProfile {
  String? bloodType;
  List<String> allergies;
  List<String> medications;
  List<String> conditions;
  String? emergencyNotes;
  String? insuranceInfo;
  String? doctorName;
  String? doctorPhone;

  MedicalProfile({
    this.bloodType,
    this.allergies = const [],
    this.medications = const [],
    this.conditions = const [],
    this.emergencyNotes,
    this.insuranceInfo,
    this.doctorName,
    this.doctorPhone,
  });

  factory MedicalProfile.fromJson(Map<String, dynamic> json) =>
      _$MedicalProfileFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalProfileToJson(this);

  @override
  String toString() {
    return 'MedicalProfile(bloodType: $bloodType, allergies: $allergies, medications: $medications, conditions: $conditions)';
  }
}
