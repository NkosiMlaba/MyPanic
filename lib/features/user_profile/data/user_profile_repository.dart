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
    await _usersRef().doc(uid).set(profile);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');
    await _usersRef().doc(uid).set(profile, SetOptions(merge: true));
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
    return _usersRef().doc(uid).snapshots().map((doc) => doc.data());
  }
}
