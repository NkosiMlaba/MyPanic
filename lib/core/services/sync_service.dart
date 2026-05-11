/// Offline-first sync service for contacts.
library;

/// Orchestrates between MyPanic.Api (source of truth) and the local SQLite
/// cache.
/// - Periodic refresh (30s)
/// - Sync on app load
/// - Sync on connectivity restored (flush-then-sync, never overlapping)
/// - Pending writes queue for offline mutations
/// - Graceful degradation when network is unavailable
///
/// Override #13 race fixes layered onto the plan body:
///   * single `_syncLock` Completer serializes flush vs sync — they never run
///     concurrently, so a slow flush can't be wiped by a parallel sync
///   * connectivity-restore handler runs flush THEN sync inside the lock
///   * before we overwrite the cache with the server list, we check
///     `hasPendingChanges()` and merge unflushed locals on top, so a 30s
///     periodic sync can't erase the contact a user added 1s ago.

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/core/services/connectivity_service.dart';
import 'package:my_panic/core/services/local_database_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(Ref ref) {
  final service = SyncService(
    localDb: ref.watch(localDatabaseServiceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    api: ref.watch(myPanicApiClientProvider),
    supabase: Supabase.instance.client,
  );
  service.initialize();
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
Stream<int> contactsCount(Ref ref) {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.contactsCountStream;
}

class SyncService {
  final LocalDatabaseService localDb;
  final ConnectivityService connectivity;
  final MyPanicApiClient api;
  final SupabaseClient supabase;

  Timer? _periodicTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  final StreamController<int> _contactsCountController =
      StreamController<int>.broadcast();
  final StreamController<List<EmergencyContact>> _contactsController =
      StreamController<List<EmergencyContact>>.broadcast();

  /// Override #13: single mutex that serializes sync vs flush. Either operation
  /// completes the Completer in `finally`; a waiter that arrives mid-op awaits
  /// the existing future and then takes the lock itself.
  Completer<void>? _syncLock;

  static const _refreshInterval = Duration(seconds: 30);
  static const _syncKey = 'contacts_last_sync';

  bool _initialized = false;

  SyncService({
    required this.localDb,
    required this.connectivity,
    required this.api,
    required this.supabase,
  });

  Stream<int> get contactsCountStream => _contactsCountController.stream;
  Stream<List<EmergencyContact>> get contactsStream =>
      _contactsController.stream;

  String? get _userId => supabase.auth.currentUser?.id;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _emitCachedData();
    await syncContacts();
    _periodicTimer = Timer.periodic(_refreshInterval, (_) => syncContacts());
    _connectivitySubscription =
        connectivity.onConnectivityChanged.listen((isOnline) {
      if (!isOnline) return;
      // Override #13: flush THEN sync, sequentially, inside the lock so they
      // can't race each other or a periodic sync.
      _withLock(() async {
        await _flushPendingChangesLocked();
        await _syncContactsLocked();
      });
    });
  }

  /// Public entry point — periodic timer and explicit refresh callers go here.
  /// Acquires the mutex so a concurrent flush can't be clobbered.
  Future<void> syncContacts() => _withLock(_syncContactsLocked);

  // ── Locking ─────────────────────────────────────────────────────────────

  Future<void> _withLock(Future<void> Function() action) async {
    while (_syncLock != null) {
      try {
        await _syncLock!.future;
      } catch (_) {
        // Previous holder failed; we still take the lock next.
      }
    }
    final lock = _syncLock = Completer<void>();
    try {
      await action();
      lock.complete();
    } catch (e, st) {
      lock.completeError(e, st);
      rethrow;
    } finally {
      if (identical(_syncLock, lock)) _syncLock = null;
    }
  }

  // ── Sync (locked) ───────────────────────────────────────────────────────

  Future<void> _syncContactsLocked() async {
    if (_userId == null) return;
    final isOnline = await connectivity.checkConnectivity();
    if (!isOnline) {
      await _emitCachedData();
      return;
    }

    try {
      final list = await api.get('/api/v1/contacts') as List<dynamic>;
      final serverContacts = list
          .cast<Map<String, dynamic>>()
          .map(_contactFromJson)
          .toList(growable: false);

      // Override #13: if the user has unflushed local writes, MERGE the server
      // list with cache instead of replacing — otherwise a periodic sync can
      // erase a contact added a second ago. Local additions/updates win until
      // they're flushed; the next sync after a successful flush converges.
      final mergedContacts = await _mergeIfPending(serverContacts);

      await localDb.replaceContacts(mergedContacts);
      await localDb.setLastSyncTime(_syncKey, DateTime.now());
      _contactsController.add(mergedContacts);
      _contactsCountController.add(mergedContacts.length);
    } catch (e, st) {
      developer.log(
        'syncContacts failed; falling back to cache',
        name: 'SyncService',
        error: e,
        stackTrace: st,
      );
      await _emitCachedData();
    }
  }

  /// If pending changes exist, replay the local cache view on top of the
  /// server list (locals win for any id present in both; locals-only stay).
  Future<List<EmergencyContact>> _mergeIfPending(
    List<EmergencyContact> serverContacts,
  ) async {
    if (!await localDb.hasPendingChanges()) return serverContacts;

    final localContacts = await localDb.getCachedContacts();
    final byId = <String, EmergencyContact>{
      for (final c in serverContacts) c.id: c,
    };
    for (final local in localContacts) {
      byId[local.id] = local;
    }
    return byId.values.toList(growable: false);
  }

  Future<void> _emitCachedData() async {
    try {
      final contacts = await localDb.getCachedContacts();
      _contactsController.add(contacts);
      _contactsCountController.add(contacts.length);
    } catch (_) {
      _contactsController.add(<EmergencyContact>[]);
      _contactsCountController.add(0);
    }
  }

  // ── Writes ──────────────────────────────────────────────────────────────

  Future<void> addContact(EmergencyContact c) => _upsert(c, 'add');
  Future<void> updateContact(EmergencyContact c) => _upsert(c, 'update');

  Future<void> _upsert(EmergencyContact contact, String op) async {
    if (_userId == null) return;

    // 1. Local cache wins immediately so the UI updates without waiting on
    // the network.
    final contacts = await localDb.getCachedContacts();
    final idx = contacts.indexWhere((c) => c.id == contact.id);
    if (idx >= 0) {
      contacts[idx] = contact;
    } else {
      contacts.add(contact);
    }
    await localDb.replaceContacts(contacts);
    await _emitCachedData();

    // 2. Push to API if online; queue otherwise. Note this does NOT take the
    // sync lock — concurrent reads (sync) are safe because of the merge step.
    final isOnline = await connectivity.checkConnectivity();
    if (isOnline) {
      try {
        await api.put('/api/v1/contacts', _toUpsertRequest(contact));
      } catch (_) {
        await _queue(op, contact);
      }
    } else {
      await _queue(op, contact);
    }
  }

  Future<void> deleteContact(String contactId) async {
    if (_userId == null) return;
    final contacts = await localDb.getCachedContacts();
    contacts.removeWhere((c) => c.id == contactId);
    await localDb.replaceContacts(contacts);
    await _emitCachedData();

    final isOnline = await connectivity.checkConnectivity();
    if (isOnline) {
      try {
        await api.delete('/api/v1/contacts/$contactId');
      } catch (_) {
        await _queueDelete(contactId);
      }
    } else {
      await _queueDelete(contactId);
    }
  }

  // ── Pending writes ──────────────────────────────────────────────────────

  Future<void> _queue(String op, EmergencyContact c) async {
    await localDb.addPendingChange(
      entityType: 'contact',
      entityId: c.id,
      operation: op,
      payload: jsonEncode(_toUpsertRequest(c)),
    );
  }

  Future<void> _queueDelete(String id) async {
    await localDb.addPendingChange(
      entityType: 'contact',
      entityId: id,
      operation: 'delete',
    );
  }

  Future<void> _flushPendingChangesLocked() async {
    if (_userId == null) return;
    final pending = await localDb.getPendingChanges();
    if (pending.isEmpty) return;

    developer.log(
      'flushing ${pending.length} pending change(s)',
      name: 'SyncService',
    );

    for (final change in pending) {
      if (change['entity_type'] != 'contact') continue;
      final entityId = change['entity_id'] as String;
      final op = change['operation'] as String;
      final payload = change['payload'] as String?;
      final changeId = change['id'] as int;

      try {
        switch (op) {
          case 'add':
          case 'update':
            if (payload != null) {
              final data = jsonDecode(payload) as Map<String, dynamic>;
              await api.put('/api/v1/contacts', data);
            }
          case 'delete':
            await api.delete('/api/v1/contacts/$entityId');
        }
        await localDb.removePendingChange(changeId);
      } catch (e, st) {
        // Stop flushing on first failure so we keep ordering. The next
        // connectivity-up event retries the same queue.
        developer.log(
          'flush failed for $changeId — aborting batch',
          name: 'SyncService',
          error: e,
          stackTrace: st,
        );
        break;
      }
    }
  }

  // ── Wire-format adapters ────────────────────────────────────────────────

  EmergencyContact _contactFromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'] as String,
      name: (json['name'] as String?) ?? '',
      phone: (json['phone'] as String?) ?? '',
      relationship: (json['relationship'] as String?) ?? '',
    );
  }

  Map<String, dynamic> _toUpsertRequest(EmergencyContact c) {
    final relationship = c.relationship.isEmpty ? null : c.relationship;
    return {
      'id': c.id,
      'name': c.name,
      'phone': c.phone,
      'relationship': relationship,
      'priority': 0,
    };
  }

  // ── Lifecycle ───────────────────────────────────────────────────────────

  Future<DateTime?> getLastSyncTime() => localDb.getLastSyncTime(_syncKey);

  void dispose() {
    _periodicTimer?.cancel();
    _connectivitySubscription?.cancel();
    _contactsCountController.close();
    _contactsController.close();
    _initialized = false;
  }
}
