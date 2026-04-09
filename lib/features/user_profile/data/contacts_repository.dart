import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/core/services/sync_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'contacts_repository.g.dart';

@riverpod
ContactsRepository contactsRepository(Ref ref) {
  final syncService = ref.watch(syncServiceProvider);
  return ContactsRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
    syncService,
  );
}

class ContactsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SyncService _syncService;

  ContactsRepository(this._firestore, this._auth, this._syncService);

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

  /// Add a contact — goes through sync service for offline support.
  Future<void> addContact(EmergencyContact contact) async {
    await _syncService.addContact(contact);
  }

  /// Update a contact — goes through sync service for offline support.
  Future<void> updateContact(EmergencyContact contact) async {
    await _syncService.updateContact(contact);
  }

  /// Delete a contact — goes through sync service for offline support.
  Future<void> deleteContact(String contactId) async {
    await _syncService.deleteContact(contactId);
  }

  /// Watch contacts from the sync service (local-first, real-time updated).
  Stream<List<EmergencyContact>> watchContacts() {
    return _syncService.contactsStream;
  }

  /// Direct Firestore stream — used only by panic alert flow where
  /// the most current data is critical and we're guaranteed online.
  Stream<List<EmergencyContact>> watchContactsDirect() {
    try {
      return _contactsRef().snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      return Stream.value([]);
    }
  }
}
