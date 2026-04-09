/// Local SQLite database for offline-first caching.
library;

///
/// Stores emergency contacts and sync metadata locally so the app
/// works without network. Firestore remains the source of truth;
/// this database is a read cache + write-ahead log for pending changes.

import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

part 'local_database_service.g.dart';

@riverpod
LocalDatabaseService localDatabaseService(Ref ref) {
  final service = LocalDatabaseService();
  ref.onDispose(() => service.close());
  return service;
}

class LocalDatabaseService {
  static const _dbName = 'my_panic_cache.db';
  static const _dbVersion = 1;
  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        relationship TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE pending_changes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        operation TEXT NOT NULL,
        payload TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sync_metadata (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  // ── Contacts Cache ──────────────────────────────────────────────────────

  /// Replace all cached contacts with a fresh list from Firestore.
  Future<void> replaceContacts(List<EmergencyContact> contacts) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('contacts');
      for (final c in contacts) {
        await txn.insert('contacts', {
          'id': c.id,
          'name': c.name,
          'phone': c.phone,
          'relationship': c.relationship,
          'updated_at': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  /// Get all cached contacts.
  Future<List<EmergencyContact>> getCachedContacts() async {
    final db = await database;
    final rows = await db.query('contacts', orderBy: 'name ASC');
    return rows
        .map((row) => EmergencyContact(
              id: row['id'] as String,
              name: row['name'] as String,
              phone: row['phone'] as String,
              relationship: row['relationship'] as String,
            ))
        .toList();
  }

  /// Get the cached contacts count without loading all data.
  Future<int> getCachedContactsCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM contacts');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // ── Pending Changes (write-ahead log) ───────────────────────────────────

  /// Queue a change to be synced when network is available.
  Future<void> addPendingChange({
    required String entityType,
    required String entityId,
    required String operation,
    String? payload,
  }) async {
    final db = await database;
    await db.insert('pending_changes', {
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation,
      'payload': payload,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Get all pending changes ordered by creation time.
  Future<List<Map<String, dynamic>>> getPendingChanges() async {
    final db = await database;
    return db.query('pending_changes', orderBy: 'created_at ASC');
  }

  /// Remove a pending change after successful sync.
  Future<void> removePendingChange(int id) async {
    final db = await database;
    await db.delete('pending_changes', where: 'id = ?', whereArgs: [id]);
  }

  /// Check if there are pending changes to sync.
  Future<bool> hasPendingChanges() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM pending_changes');
    return (Sqflite.firstIntValue(result) ?? 0) > 0;
  }

  // ── Sync Metadata ──────────────────────────────────────────────────────

  /// Store when contacts were last synced from Firestore.
  Future<void> setLastSyncTime(String key, DateTime time) async {
    final db = await database;
    await db.insert(
      'sync_metadata',
      {
        'key': key,
        'value': time.toIso8601String(),
        'updated_at': time.millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get the last sync time for a given key.
  Future<DateTime?> getLastSyncTime(String key) async {
    final db = await database;
    final rows =
        await db.query('sync_metadata', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return null;
    return DateTime.tryParse(rows.first['value'] as String);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
