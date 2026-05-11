import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/user_profile/presentation/providers/user_profile_provider.dart';

/// Provides the current user's medical profile.
final medicalProfileProvider = Provider<MedicalProfile?>((ref) {
  final userProfile = ref.watch(userProfileProvider).value;
  return userProfile?.medicalProfile;
});
