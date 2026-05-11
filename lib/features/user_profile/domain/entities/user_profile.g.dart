// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  uid: json['uid'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  medicalProfile: MedicalProfile.fromJson(
    json['medicalProfile'] as Map<String, dynamic>,
  ),
  isProfileComplete: json['isProfileComplete'] as bool? ?? false,
  countdownDuration: (json['countdownDuration'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'medicalProfile': instance.medicalProfile.toJson(),
      'isProfileComplete': instance.isProfileComplete,
      'countdownDuration': instance.countdownDuration,
    };
