import 'package:my_panic/features/auth/presentation/providers/auth_notifier.dart';
import 'package:my_panic/features/user_profile/data/user_profile_repository.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_provider.g.dart';

@riverpod
Stream<UserProfile?> userProfile(UserProfileRef ref) {
  // Watch auth state so this provider re-initializes when the user logs in/out.
  // Without this, the stream is created before auth completes and currentUserId
  // is null, causing the stream to immediately emit null.
  final authState = ref.watch(authNotifierProvider);
  final user = authState.valueOrNull;

  if (user == null) {
    // No user logged in yet — return a stream that emits null.
    return Stream.value(null);
  }

  return ref.watch(userProfileRepositoryProvider).watchUserProfile();
}
