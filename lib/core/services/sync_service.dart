/// Offline-first sync service for contacts and user data.
library;

///
/// Orchestrates data synchronization between Firestore (source of truth)
/// and the local SQLite cache. Handles:
///
/// - Periodic refresh (every 5 minutes)
/// - Sync on app load
/// - Sync on connectivity restored
/// - Immediate sync on data changes
/// - Pending writes queue for offline mutations
/// - Graceful degradation when network is unavailable

import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/core/services/connectivity_service.dart';
import 'package:my_panic/core/services/local_database_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(Ref ref) {
  final localDb = ref.watch(localDatabaseServiceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final service = SyncService(
    localDb: localDb,
    connectivity: connectivity,
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  );
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
}

/// Provides a reactive stream of contacts count from the sync service.
@riverpod
Stream<int> contactsCount(Ref ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.contactsCountStream;
}

class SyncService {
  final LocalDatabaseService localDb;
  final ConnectivityService connectivity;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  Timer? _periodicTimer;
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<QuerySnapshot<EmergencyContact>>? _firestoreSubscription;

  final StreamController<int> _contactsCountController =
      StreamController<int>.broadcast();
  final StreamController<List<EmergencyContact>> _contactsController =
      StreamController<List<EmergencyContact>>.broadcast();

  static const _refreshInterval = Duration(minutes: 5);
  static const _syncKey = 'contacts_last_sync';

  bool _initialized = false;

  SyncService({
    required this.localDb,
    required this.connectivity,
    required this.firestore,
    required this.auth,
  });

  /// Stream of contacts count — updates on every sync.
  Stream<int> get contactsCountStream => _contactsCountController.stream;

  /// Stream of full contacts list — updates on every sync.
  Stream<List<EmergencyContact>> get contactsStream =>
      _contactsController.stream;

  /// Initialize the sync service: load local cache, start listeners.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // 1. Emit cached data immediately
    await _emitCachedData();

    // 2. Try an initial sync
    await syncContacts();

    // 3. Start periodic refresh (every 5 minutes)
    _periodicTimer = Timer.periodic(_refreshInterval, (_) => syncContacts());

    // 4. Listen for connectivity changes — sync when network returns
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        _flushPendingChanges();
        syncContacts();
      }
    });

    // 5. Listen to Firestore real-time updates when online
    _startFirestoreListener();
  }

  /// Sync contacts from Firestore → local cache.
  Future<void> syncContacts() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final isOnline = await connectivity.checkConnectivity();
    if (!isOnline) {
      // Offline — just emit cached data
      await _emitCachedData();
      return;
    }

    try {
      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('contacts')
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 10));

      final contacts = snapshot.docs.map((doc) {
        final data = doc.data();
        return EmergencyContact(
          id: doc.id,
          name: data['name'] as String? ?? '',
          phone: data['phone'] as String? ?? '',
          relationship: data['relationship'] as String? ?? '',
        );
      }).toList();

      // Update local cache
      await localDb.replaceContacts(contacts);
      await localDb.setLastSyncTime(_syncKey, DateTime.now());

      // Emit updated data
      _contactsController.add(contacts);
      _contactsCountController.add(contacts.length);
    } catch (e) {
      // Network error or timeout — fall back to cache
      print('[SyncService] syncContacts failed: $e — using cache');
      await _emitCachedData();
    }
  }

  /// Start listening to Firestore real-time updates.
  void _startFirestoreListener() {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    _firestoreSubscription?.cancel();
    _firestoreSubscription = firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .withConverter<EmergencyContact>(
          fromFirestore: (snap, _) => EmergencyContact.fromJson(snap.data()!),
          toFirestore: (c, _) => c.toJson(),
        )
        .snapshots()
        .listen(
      (snapshot) async {
        final contacts = snapshot.docs.map((doc) => doc.data()).toList();
        await localDb.replaceContacts(contacts);
        await localDb.setLastSyncTime(_syncKey, DateTime.now());
        _contactsController.add(contacts);
        _contactsCountController.add(contacts.length);
      },
      onError: (e) {
        print('[SyncService] Firestore listener error: $e');
      },
    );
  }

  /// Emit data from the local cache.
  Future<void> _emitCachedData() async {
    try {
      final contacts = await localDb.getCachedContacts();
      _contactsController.add(contacts);
      _contactsCountController.add(contacts.length);
    } catch (e) {
      // Database not ready yet — emit empty
      _contactsController.add([]);
      _contactsCountController.add(0);
    }
  }

  // ── Offline Writes ─────────────────────────────────────────────────────

  /// Add a contact — writes to Firestore immediately if online,
  /// otherwise queues for later sync.
  Future<void> addContact(EmergencyContact contact) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    // Always update local cache immediately
    final contacts = await localDb.getCachedContacts();
    contacts.add(contact);
    await localDb.replaceContacts(contacts);
    await _emitCachedData();

    final isOnline = await connectivity.checkConnectivity();
    if (isOnline) {
      try {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .doc(contact.id)
            .set(contact.toJson())
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        // Failed — queue for later
        await _queueContactChange('add', contact);
      }
    } else {
      await _queueContactChange('add', contact);
    }
  }

  /// Update a contact — writes to Firestore immediately if online.
  Future<void> updateContact(EmergencyContact contact) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    // Update local cache immediately
    final contacts = await localDb.getCachedContacts();
    final idx = contacts.indexWhere((c) => c.id == contact.id);
    if (idx >= 0) {
      contacts[idx] = contact;
    } else {
      contacts.add(contact);
    }
    await localDb.replaceContacts(contacts);
    await _emitCachedData();

    final isOnline = await connectivity.checkConnectivity();
    if (isOnline) {
      try {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .doc(contact.id)
            .set(contact.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        await _queueContactChange('update', contact);
      }
    } else {
      await _queueContactChange('update', contact);
    }
  }

  /// Delete a contact — removes from Firestore immediately if online.
  Future<void> deleteContact(String contactId) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    // Remove from local cache immediately
    final contacts = await localDb.getCachedContacts();
    contacts.removeWhere((c) => c.id == contactId);
    await localDb.replaceContacts(contacts);
    await _emitCachedData();

    final isOnline = await connectivity.checkConnectivity();
    if (isOnline) {
      try {
        await firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .doc(contactId)
            .delete()
            .timeout(const Duration(seconds: 5));
      } catch (e) {
        await _queueContactDelete(contactId);
      }
    } else {
      await _queueContactDelete(contactId);
    }
  }

  Future<void> _queueContactChange(
      String operation, EmergencyContact contact) async {
    await localDb.addPendingChange(
      entityType: 'contact',
      entityId: contact.id,
      operation: operation,
      payload: jsonEncode(contact.toJson()),
    );
  }

  Future<void> _queueContactDelete(String contactId) async {
    await localDb.addPendingChange(
      entityType: 'contact',
      entityId: contactId,
      operation: 'delete',
    );
  }

  /// Flush all pending changes to Firestore.
  Future<void> _flushPendingChanges() async {
    final uid = auth.currentUser?.uid;
    if (uid == null) return;

    final pending = await localDb.getPendingChanges();
    if (pending.isEmpty) return;

    print('[SyncService] Flushing ${pending.length} pending changes');

    for (final change in pending) {
      final entityType = change['entity_type'] as String;
      if (entityType != 'contact') continue;

      final entityId = change['entity_id'] as String;
      final operation = change['operation'] as String;
      final payload = change['payload'] as String?;
      final changeId = change['id'] as int;

      try {
        final ref = firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .doc(entityId);

        switch (operation) {
          case 'add':
          case 'update':
            if (payload != null) {
              final data = jsonDecode(payload) as Map<String, dynamic>;
              await ref
                  .set(data, SetOptions(merge: true))
                  .timeout(const Duration(seconds: 5));
            }
          case 'delete':
            await ref.delete().timeout(const Duration(seconds: 5));
        }

        await localDb.removePendingChange(changeId);
      } catch (e) {
        // Stop flushing on error — will retry on next connectivity change
        print('[SyncService] Failed to flush change $changeId: $e');
        break;
      }
    }
  }

  /// Get the last sync time.
  Future<DateTime?> getLastSyncTime() => localDb.getLastSyncTime(_syncKey);

  void dispose() {
    _periodicTimer?.cancel();
    _connectivitySubscription?.cancel();
    _firestoreSubscription?.cancel();
    _contactsCountController.close();
    _contactsController.close();
    _initialized = false;
  }
}
