import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/features/auth/data/auth_repository.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

class _MockSession extends Mock implements Session {}

class _MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late _MockSupabaseClient supabase;
  late _MockGoTrueClient auth;
  late AuthRepository repo;

  setUp(() {
    supabase = _MockSupabaseClient();
    auth = _MockGoTrueClient();
    when(() => supabase.auth).thenReturn(auth);
    repo = AuthRepository(supabase);
  });

  group('AuthRepository', () {
    // ── Path 6: handleError swallows token-refresh failures ─────────────
    test(
      'authStateChanges swallows upstream errors instead of crashing the stream',
      () async {
        final controller = StreamController<AuthState>.broadcast();
        when(() => auth.onAuthStateChange).thenAnswer((_) => controller.stream);

        final emitted = <Object?>[];
        Object? streamError;
        final sub = repo.authStateChanges.listen(
          emitted.add,
          onError: (Object e) => streamError = e,
        );

        // Pump an error frame onto the upstream — handleError should eat it.
        controller.addError(StateError('token refresh failed'));
        // Then push a real signed-out event to prove the stream is still live.
        final signedOut = AuthState(AuthChangeEvent.signedOut, null);
        controller.add(signedOut);
        await Future<void>.delayed(Duration.zero);

        expect(streamError, isNull, reason: 'error must be swallowed');
        expect(emitted, [null], reason: 'signedOut → AppUser? null');

        await sub.cancel();
        await controller.close();
      },
    );

    // ── Path 7: signIn populates currentUser ────────────────────────────
    test('signInWithEmailAndPassword + currentUser returns the AppUser',
        () async {
      final user = _MockUser();
      when(() => user.id).thenReturn('uuid-1');
      when(() => user.email).thenReturn('alice@kizuri.test');
      when(() => user.emailConfirmedAt).thenReturn('2026-05-11T00:00:00Z');

      when(() => auth.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => _MockAuthResponse());
      when(() => auth.currentUser).thenReturn(user);

      await repo.signInWithEmailAndPassword('alice@kizuri.test', 'pw');
      final me = repo.currentUser;
      expect(me, isNotNull);
      expect(me!.id, 'uuid-1');
      expect(me.email, 'alice@kizuri.test');
      expect(me.emailVerified, isTrue);
    });

    // ── Path 8: signUp emits an empty-session AppUser? null state ───────
    test(
      'signUp with email confirmation enabled leaves currentUser null'
      ' (Supabase returns no session until the user clicks the email link)',
      () async {
        when(() => auth.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
              emailRedirectTo: any(named: 'emailRedirectTo'),
            )).thenAnswer((_) async => _MockAuthResponse());
        when(() => auth.currentUser).thenReturn(null);

        await repo.createUserWithEmailAndPassword('new@kizuri.test', 'pw');
        expect(repo.currentUser, isNull);
      },
    );

    test('signOut delegates to GoTrueClient.signOut', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});
      await repo.signOut();
      verify(() => auth.signOut()).called(1);
    });
  });
}
