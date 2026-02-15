import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String uid,
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required MedicalProfile medicalProfile,
    @Default(false) bool isProfileComplete,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
