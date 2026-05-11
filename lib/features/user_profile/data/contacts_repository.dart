import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/core/services/sync_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'contacts_repository.g.dart';

@riverpod
ContactsRepository contactsRepository(Ref ref) {
  return ContactsRepository(
    ref.watch(syncServiceProvider),
    ref.watch(myPanicApiClientProvider),
  );
}

class ContactsRepository {
  final SyncService _sync;
  final MyPanicApiClient _api;

  ContactsRepository(this._sync, this._api);

  Future<void> addContact(EmergencyContact contact) =>
      _sync.addContact(contact);

  Future<void> updateContact(EmergencyContact contact) =>
      _sync.updateContact(contact);

  Future<void> deleteContact(String contactId) =>
      _sync.deleteContact(contactId);

  /// Local-first stream — same surface as the old Firestore-backed repo.
  Stream<List<EmergencyContact>> watchContacts() => _sync.contactsStream;

  /// Direct API stream — used by the panic alert flow where the most current
  /// recipient list is critical. Single fetch wrapped as a Stream to match the
  /// old Firestore signature.
  Stream<List<EmergencyContact>> watchContactsDirect() async* {
    try {
      final list = await _api.get('/api/v1/contacts') as List<dynamic>;
      yield list
          .cast<Map<String, dynamic>>()
          .map(
            (j) => EmergencyContact(
              id: j['id'] as String,
              name: (j['name'] as String?) ?? '',
              phone: (j['phone'] as String?) ?? '',
              relationship: (j['relationship'] as String?) ?? '',
            ),
          )
          .toList(growable: false);
    } on ApiException {
      yield <EmergencyContact>[];
    }
  }
}
