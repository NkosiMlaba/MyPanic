import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';
import 'package:my_panic/features/user_profile/data/contacts_repository.dart';
import 'package:my_panic/features/user_profile/presentation/providers/contacts_provider.dart';
import 'package:uuid/uuid.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsListProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: contactsAsync.when(
        data: (contacts) {
          if (contacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 60,
                    color: AppTheme.dividerBrand,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No contacts added yet.',
                    style: TextStyle(color: AppTheme.textBrandMuted),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => _showContactDialog(context, ref),
                    child: const Text('Add Your First Contact'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.brandPink.withValues(alpha: 0.15),
                    child: Text(
                      contact.name.isNotEmpty
                          ? contact.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: AppTheme.brandPink, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      color: AppTheme.textBrandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${contact.relationship} • ${contact.phone}',
                    style: const TextStyle(color: AppTheme.textBrandSecondary),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: AppTheme.textBrandMuted),
                        onPressed: () =>
                            _showContactDialog(context, ref, contact: contact),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: AppTheme.errorRed,
                        ),
                        onPressed: () =>
                            _deleteContact(context, ref, contact.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandPink),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppTheme.errorRed),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showContactDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteContact(
    BuildContext context,
    WidgetRef ref,
    String contactId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBrand,
        title: const Text(
          'Delete Contact?',
          style: TextStyle(color: AppTheme.textBrandPrimary),
        ),
        content: const Text(
          'Are you sure you want to remove this contact?',
          style: TextStyle(color: AppTheme.textBrandSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: AppTheme.errorRed),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(contactsRepositoryProvider).deleteContact(contactId);
    }
  }

  void _showContactDialog(
    BuildContext context,
    WidgetRef ref, {
    EmergencyContact? contact,
  }) {
    showDialog(
      context: context,
      builder: (context) => _ContactDialog(contact: contact),
    );
  }
}

class _ContactDialog extends ConsumerStatefulWidget {
  final EmergencyContact? contact;

  const _ContactDialog({this.contact});

  @override
  ConsumerState<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends ConsumerState<_ContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _relationCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.contact?.name ?? '');
    _phoneCtrl = TextEditingController(text: widget.contact?.phone ?? '');
    _relationCtrl = TextEditingController(
      text: widget.contact?.relationship ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _relationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(contactsRepositoryProvider);

      final contact = EmergencyContact(
        id: widget.contact?.id ?? const Uuid().v4(),
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        relationship: _relationCtrl.text.trim(),
      );

      if (widget.contact == null) {
        await repo.addContact(contact);
      } else {
        await repo.updateContact(contact);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surfaceBrand,
      title: Text(
        widget.contact == null ? 'Add Contact' : 'Edit Contact',
        style: const TextStyle(color: AppTheme.textBrandPrimary),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _relationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Relationship (e.g. Mom, Partner)',
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
