import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';
import 'package:my_panic/features/user_profile/data/contacts_repository.dart';

final contactsListProvider = StreamProvider<List<EmergencyContact>>((ref) {
  return ref.watch(contactsRepositoryProvider).watchContacts();
});
