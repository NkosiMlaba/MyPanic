// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicalProfile _$MedicalProfileFromJson(Map<String, dynamic> json) =>
    MedicalProfile(
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
      insuranceInfo: json['insuranceInfo'] as String?,
      doctorName: json['doctorName'] as String?,
      doctorPhone: json['doctorPhone'] as String?,
    );

Map<String, dynamic> _$MedicalProfileToJson(MedicalProfile instance) =>
    <String, dynamic>{
      'bloodType': instance.bloodType,
      'allergies': instance.allergies,
      'medications': instance.medications,
      'conditions': instance.conditions,
      'emergencyNotes': instance.emergencyNotes,
      'insuranceInfo': instance.insuranceInfo,
      'doctorName': instance.doctorName,
      'doctorPhone': instance.doctorPhone,
    };
