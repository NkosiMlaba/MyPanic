import 'package:my_panic/features/user_profile/data/user_profile_repository.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_provider.g.dart';

@riverpod
Stream<UserProfile?> userProfile(UserProfileRef ref) {
  return ref.watch(userProfileRepositoryProvider).watchUserProfile();
}
