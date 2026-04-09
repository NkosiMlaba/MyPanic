import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/services/sync_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';
import 'package:my_panic/features/user_profile/data/contacts_repository.dart';

final contactsListProvider = StreamProvider<List<EmergencyContact>>((ref) {
  return ref.watch(contactsRepositoryProvider).watchContacts();
});

/// Provides the current contacts count — reactive, updated by sync service.
final contactsCountProvider = StreamProvider<int>((ref) {
  return ref.watch(syncServiceProvider).contactsCountStream;
});
