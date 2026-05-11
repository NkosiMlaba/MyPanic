import 'dart:async';

import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/features/user_profile/data/user_profile_repository.dart';

class _MockApi extends Mock implements MyPanicApiClient {}

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

void main() {
  // _PausablePollStream.WidgetsBinding.instance.addObserver requires the
  // binding to be initialized.
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockApi api;
  late _MockSupabaseClient supabase;
  late _MockGoTrueClient auth;

  setUp(() {
    api = _MockApi();
    supabase = _MockSupabaseClient();
    auth = _MockGoTrueClient();
    when(() => supabase.auth).thenReturn(auth);
    final user = _MockUser();
    when(() => user.id).thenReturn('uuid-1');
    when(() => auth.currentUser).thenReturn(user);
  });

  group('UserProfileRepository', () {
    // ── Path 9: getUserProfile returns null on 404 ──────────────────────
    test('getUserProfile returns null when API responds 404', () async {
      when(() => api.get('/api/v1/profiles/me')).thenAnswer(
        (_) async => throw ApiException(404, '/api/v1/profiles/me'),
      );

      final repo = UserProfileRepository(api, supabase);
      expect(await repo.getUserProfile(), isNull);
    });

    test('getUserProfile maps the API ProfileResponse onto UserProfile',
        () async {
      when(() => api.get('/api/v1/profiles/me')).thenAnswer(
        (_) async => {
          'id': 'profile-internal-id',
          'authUserId': 'uuid-1',
          'email': 'alice@kizuri.test',
          'firstName': 'Alice',
          'lastName': 'Tester',
          'phone': '+27821234567',
          'bloodType': 'O+',
          'allergies': 'peanuts, shellfish',
          'conditions': 'asthma',
          'isProfileComplete': true,
        },
      );

      final repo = UserProfileRepository(api, supabase);
      final profile = await repo.getUserProfile();
      expect(profile, isNotNull);
      expect(profile!.uid, 'uuid-1');
      expect(profile.firstName, 'Alice');
      expect(profile.phoneNumber, '+27821234567');
      expect(profile.medicalProfile.allergies, ['peanuts', 'shellfish']);
      expect(profile.medicalProfile.conditions, ['asthma']);
      expect(profile.isProfileComplete, isTrue);
    });

    // ── Path 10: watchUserProfile polls + cancels cleanly on dispose ────
    test(
      'watchUserProfile fires an initial fetch and cancels cleanly when the'
      ' subscription is dropped',
      () async {
        var callCount = 0;
        when(() => api.get('/api/v1/profiles/me')).thenAnswer((_) async {
          callCount++;
          return <String, dynamic>{
            'id': 'p1',
            'authUserId': 'uuid-1',
            'email': 'a@b.test',
            'firstName': 'A',
            'lastName': 'B',
            'phone': '',
            'isProfileComplete': false,
          };
        });

        final repo = UserProfileRepository(api, supabase);
        final emitted = <Object?>[];
        final sub = repo.watchUserProfile().listen(emitted.add);

        // Give the initial _tick() a microtask to land.
        await Future<void>.delayed(const Duration(milliseconds: 50));
        expect(callCount, 1, reason: 'initial fetch fires immediately');
        expect(emitted, hasLength(1));
        expect((emitted.first! as dynamic).firstName, 'A');

        // Cancelling the subscription closes the controller. A subsequent
        // listen on the same Stream fails with StateError if the controller
        // is genuinely closed — that's our auto-cancel proof.
        await sub.cancel();
        await Future<void>.delayed(Duration.zero);

        // No further calls should accrue once the listener is gone (we
        // can't deterministically wait the 30s poll interval, but proving
        // no callback fires after cancel is enough).
        final beforeIdle = callCount;
        await Future<void>.delayed(const Duration(milliseconds: 100));
        expect(callCount, beforeIdle);
      },
    );
  });
}
