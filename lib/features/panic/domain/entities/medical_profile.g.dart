// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MedicalProfileImpl _$$MedicalProfileImplFromJson(Map<String, dynamic> json) =>
    _$MedicalProfileImpl(
      bloodType: json['bloodType'] as String?,
      allergies:
          (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      medications:
          (json['medications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      conditions:
          (json['conditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      emergencyNotes: json['emergencyNotes'] as String?,
      doctorName: json['doctorName'] as String?,
      doctorPhone: json['doctorPhone'] as String?,
    );

Map<String, dynamic> _$$MedicalProfileImplToJson(
  _$MedicalProfileImpl instance,
) => <String, dynamic>{
  'bloodType': instance.bloodType,
  'allergies': instance.allergies,
  'medications': instance.medications,
  'conditions': instance.conditions,
  'emergencyNotes': instance.emergencyNotes,
  'doctorName': instance.doctorName,
  'doctorPhone': instance.doctorPhone,
};
