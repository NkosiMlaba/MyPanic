import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/core/services/connectivity_service.dart';
import 'package:my_panic/core/services/local_database_service.dart';
import 'package:my_panic/core/services/sync_service.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';

class _MockApi extends Mock implements MyPanicApiClient {}

class _MockLocalDb extends Mock implements LocalDatabaseService {}

class _MockConnectivity extends Mock implements ConnectivityService {}

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

void main() {
  setUpAll(() {
    registerFallbackValue(<EmergencyContact>[]);
    registerFallbackValue(DateTime.now());
  });

  late _MockApi api;
  late _MockLocalDb localDb;
  late _MockConnectivity connectivity;
  late _MockSupabaseClient supabase;
  late _MockGoTrueClient auth;
  late StreamController<bool> connectivityChanges;

  setUp(() {
    api = _MockApi();
    localDb = _MockLocalDb();
    connectivity = _MockConnectivity();
    supabase = _MockSupabaseClient();
    auth = _MockGoTrueClient();
    connectivityChanges = StreamController<bool>.broadcast();

    final user = _MockUser();
    when(() => user.id).thenReturn('uuid-1');
    when(() => supabase.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(user);
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityChanges.stream);
    when(() => connectivity.checkConnectivity()).thenAnswer((_) async => true);
    when(() => localDb.getCachedContacts()).thenAnswer((_) async => []);
    when(() => localDb.replaceContacts(any())).thenAnswer((_) async {});
    when(() => localDb.setLastSyncTime(any(), any())).thenAnswer((_) async {});
    when(() => localDb.hasPendingChanges()).thenAnswer((_) async => false);
  });

  tearDown(() async {
    await connectivityChanges.close();
  });

  SyncService build() => SyncService(
        localDb: localDb,
        connectivity: connectivity,
        api: api,
        supabase: supabase,
      );

  group('SyncService', () {
    // ── Path 11: merge-not-replace when local pending changes exist ─────
    test(
      'syncContacts merges server list with cached locals when'
      ' hasPendingChanges() is true (locals win by id)',
      () async {
        // Server has c-1 (older name) and c-2 (server-only).
        when(() => api.get('/api/v1/contacts')).thenAnswer(
          (_) async => [
            {
              'id': 'c-1',
              'name': 'Server Name',
              'phone': '+27-server-1',
              'relationship': 'sister',
            },
            {
              'id': 'c-2',
              'name': 'Server Only',
              'phone': '+27-server-2',
              'relationship': null,
            },
          ],
        );

        // Local cache has c-1 with the FRESHER local edit, and c-3 added
        // offline (not yet on the server).
        when(() => localDb.getCachedContacts()).thenAnswer(
          (_) async => const [
            EmergencyContact(
              id: 'c-1',
              name: 'Local Edit',
              phone: '+27-local-1',
              relationship: 'sister',
            ),
            EmergencyContact(
              id: 'c-3',
              name: 'Local Only',
              phone: '+27-local-3',
              relationship: 'friend',
            ),
          ],
        );

        // The override #13 hot path — pending writes exist.
        when(() => localDb.hasPendingChanges()).thenAnswer((_) async => true);

        List<EmergencyContact>? written;
        when(() => localDb.replaceContacts(any())).thenAnswer((invocation) async {
          written = invocation.positionalArguments[0]
              as List<EmergencyContact>;
        });

        final service = build();
        await service.syncContacts();

        expect(written, isNotNull);
        // Locals win for c-1; server-only c-2 stays; local-only c-3 stays.
        final byId = {for (final c in written!) c.id: c};
        expect(byId.keys.toSet(), {'c-1', 'c-2', 'c-3'});
        expect(byId['c-1']!.name, 'Local Edit',
            reason: 'local must win over server when pending writes exist');
        expect(byId['c-2']!.name, 'Server Only');
        expect(byId['c-3']!.name, 'Local Only');

        service.dispose();
      },
    );

    test(
      'syncContacts overwrites cache with server list when no pending writes',
      () async {
        when(() => api.get('/api/v1/contacts')).thenAnswer(
          (_) async => [
            {
              'id': 'c-1',
              'name': 'Server Wins',
              'phone': '+27',
              'relationship': null,
            },
          ],
        );
        when(() => localDb.getCachedContacts()).thenAnswer(
          (_) async => const [
            EmergencyContact(
              id: 'c-old',
              name: 'Stale',
              phone: '+27',
              relationship: '',
            ),
          ],
        );
        when(() => localDb.hasPendingChanges()).thenAnswer((_) async => false);

        List<EmergencyContact>? written;
        when(() => localDb.replaceContacts(any())).thenAnswer((invocation) async {
          written = invocation.positionalArguments[0]
              as List<EmergencyContact>;
        });

        final service = build();
        await service.syncContacts();

        expect(written!.map((c) => c.id).toList(), ['c-1']);
        service.dispose();
      },
    );

    // ── Path 12: connectivity-restore runs flush THEN sync, never racing ─
    test(
      'connectivity-restore handler runs _flushPendingChanges before'
      ' syncContacts and serializes them with the lock',
      () async {
        // Pending changes that should be flushed first.
        when(() => localDb.getPendingChanges()).thenAnswer(
          (_) async => [
            {
              'id': 1,
              'entity_type': 'contact',
              'entity_id': 'c-1',
              'operation': 'add',
              'payload':
                  '{"id":"c-1","name":"X","phone":"+1","relationship":null,"priority":0}',
            },
          ],
        );
        when(() => localDb.removePendingChange(any())).thenAnswer((_) async {});

        // Capture the order of ops by appending to a shared log.
        final ops = <String>[];
        when(() => api.put('/api/v1/contacts', any())).thenAnswer((_) async {
          // Slow down the flush so a parallel sync would obviously race.
          await Future<void>.delayed(const Duration(milliseconds: 30));
          ops.add('flush.put');
          return null;
        });
        when(() => api.get('/api/v1/contacts')).thenAnswer((_) async {
          ops.add('sync.get');
          return <Map<String, dynamic>>[];
        });

        final service = build();
        // initialize() registers the connectivity-restore subscription. It also
        // fires an initial syncContacts; we let that run, then drive the
        // restore handler.
        when(() => api.get('/api/v1/contacts')).thenAnswer((_) async {
          ops.add('sync.get');
          return <Map<String, dynamic>>[];
        });
        await service.initialize();
        ops.clear(); // discard the boot-time sync.get

        connectivityChanges.add(true);

        // Wait long enough for both ops + the lock dance to complete.
        await Future<void>.delayed(const Duration(milliseconds: 150));

        expect(ops, ['flush.put', 'sync.get'],
            reason: 'flush must complete before sync starts');

        service.dispose();
      },
    );
  });
}
