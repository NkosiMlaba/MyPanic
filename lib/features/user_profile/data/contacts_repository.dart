import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'contacts_repository.g.dart';

@riverpod
ContactsRepository contactsRepository(ContactsRepositoryRef ref) {
  return ContactsRepository(FirebaseFirestore.instance, FirebaseAuth.instance);
}

class ContactsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ContactsRepository(this._firestore, this._auth);

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference<EmergencyContact> _contactsRef() {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not authenticated');

    return _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .withConverter<EmergencyContact>(
          fromFirestore: (snapshots, _) =>
              EmergencyContact.fromJson(snapshots.data()!),
          toFirestore: (contact, _) => contact.toJson(),
        );
  }

  Future<void> addContact(EmergencyContact contact) async {
    await _contactsRef().doc(contact.id).set(contact);
  }

  Future<void> updateContact(EmergencyContact contact) async {
    await _contactsRef().doc(contact.id).update(contact.toJson());
  }

  Future<void> deleteContact(String contactId) async {
    await _contactsRef().doc(contactId).delete();
  }

  Stream<List<EmergencyContact>> watchContacts() {
    try {
      return _contactsRef().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      // Return empty list if not authenticated or error
      return Stream.value([]);
    }
  }
}
