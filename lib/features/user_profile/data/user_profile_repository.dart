import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';

part 'user_profile_repository.g.dart';

@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) {
  return UserProfileRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
}

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  UserProfileRepository(this._firestore, this._auth);

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<UserProfile> _usersRef() {
    return _firestore
        .collection('users')
        .withConverter<UserProfile>(
          fromFirestore: (snapshots, _) =>
              UserProfile.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Future<void> createUserProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');
    // Use timeout so the UI doesn't hang indefinitely if offline
    try {
      await _usersRef()
          .doc(uid)
          .set(profile)
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      // Timeout exceptions are expected if offline, but the data is still saved
      // to the local cache, so we can ignore the timeout here and proceed.
      if (e is! TimeoutException) rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');
    try {
      await _usersRef()
          .doc(uid)
          .set(profile, SetOptions(merge: true))
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      if (e is! TimeoutException) rethrow;
    }
  }

  Future<UserProfile?> getUserProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;
    final doc = await _usersRef().doc(uid).get();
    return doc.data();
  }

  Stream<UserProfile?> watchUserProfile() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _usersRef()
        .doc(uid)
        // includeMetadataChanges lets us inspect where the snapshot came from
        .snapshots(includeMetadataChanges: true)
        .where((doc) {
          // If the document doesn't exist AND it's from the local cache,
          // it means we're still waiting for the server response.
          // Skip this emission so the provider stays in AsyncLoading.
          if (!doc.exists && doc.metadata.isFromCache) {
            print(
              '[UserProfileRepository] Snapshot from cache and !exists. Ignoring.',
            );
            return false;
          }
          return true;
        })
        .map((doc) => doc.data());
  }
}
