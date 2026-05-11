import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';

class _MockHttpClient extends Mock implements http.Client {}

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockSession extends Mock implements Session {}

class _MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  setUpAll(() {
    // Mocktail needs explicit fallbacks for any non-primitive types passed via
    // matchers. We use Uri-typed any() in stubs.
    registerFallbackValue(Uri.parse('http://x.test'));
    registerFallbackValue(<String, String>{});
  });

  late _MockHttpClient http_;
  late _MockSupabaseClient supabase;
  late _MockGoTrueClient auth;
  late MyPanicApiClient client;

  setUp(() {
    http_ = _MockHttpClient();
    supabase = _MockSupabaseClient();
    auth = _MockGoTrueClient();

    when(() => supabase.auth).thenReturn(auth);
    // Default: no session — keeps the /health probe quiet (no 401).
    when(() => auth.currentSession).thenReturn(null);

    // The /health probe always fires once; default to a benign 200 so it
    // doesn't interfere with the test under inspection. Tests that care
    // about /health override this.
    when(
      () => http_.get(
        any(that: predicate<Uri>((u) => u.path.endsWith('/health'))),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) async => http.Response('{}', 200));

    client = MyPanicApiClient(http_, supabase);
  });

  tearDown(() {
    client.dispose();
  });

  group('MyPanicApiClient', () {
    // ── Path 1 (CRITICAL): 401-retry-then-refresh-then-success ──────────
    test(
      'CRITICAL: refreshes session and retries once on 401, then succeeds',
      () async {
        // Session present → refresh path enabled.
        final session = _MockSession();
        when(() => session.refreshToken).thenReturn('rt-abc');
        when(() => auth.currentSession).thenReturn(session);
        when(() => session.accessToken).thenReturn('expired-token');

        // refreshSession swaps the access token to a fresh one.
        when(() => auth.refreshSession()).thenAnswer((_) async {
          when(() => session.accessToken).thenReturn('fresh-token');
          return _MockAuthResponse();
        });

        // First GET /api/v1/profiles/me → 401, second → 200.
        var callCount = 0;
        final capturedHeaders = <Map<String, String>>[];
        when(
          () => http_.get(
            any(
              that: predicate<Uri>((u) => u.path.endsWith('/profiles/me')),
            ),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((invocation) async {
          callCount++;
          capturedHeaders.add(
            invocation.namedArguments[#headers] as Map<String, String>,
          );
          if (callCount == 1) {
            return http.Response('{"error":"unauthorized"}', 401);
          }
          return http.Response('{"id":"p1","email":"a@b.test"}', 200);
        });

        final result = await client.get('/api/v1/profiles/me');

        expect(result, isA<Map<String, dynamic>>());
        expect((result as Map)['id'], 'p1');
        expect(callCount, 2, reason: 'should retry exactly once');
        verify(() => auth.refreshSession()).called(1);
        // The first call carried the expired token, the retry carried fresh.
        expect(capturedHeaders[0]['Authorization'], 'Bearer expired-token');
        expect(capturedHeaders[1]['Authorization'], 'Bearer fresh-token');
      },
    );

    test('does NOT retry when there is no refresh token', () async {
      final session = _MockSession();
      when(() => session.refreshToken).thenReturn(null);
      when(() => session.accessToken).thenReturn('whatever');
      when(() => auth.currentSession).thenReturn(session);

      var callCount = 0;
      when(
        () => http_.get(
          any(that: predicate<Uri>((u) => u.path.endsWith('/profiles/me'))),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async {
        callCount++;
        return http.Response('{"error":"unauthorized"}', 401);
      });

      await expectLater(
        client.get('/api/v1/profiles/me'),
        throwsA(isA<ApiException>()),
      );
      expect(callCount, 1);
      verifyNever(() => auth.refreshSession());
    });

    // ── Path 2: bearer attached when session present ────────────────────
    test('attaches bearer token when a session is present', () async {
      final session = _MockSession();
      when(() => session.accessToken).thenReturn('tok-123');
      when(() => session.refreshToken).thenReturn('rt');
      when(() => auth.currentSession).thenReturn(session);

      Map<String, String>? captured;
      when(
        () => http_.get(
          any(that: predicate<Uri>((u) => u.path.endsWith('/contacts'))),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        captured =
            invocation.namedArguments[#headers] as Map<String, String>;
        return http.Response('[]', 200);
      });

      await client.get('/api/v1/contacts');
      expect(captured, isNotNull);
      expect(captured!['Authorization'], 'Bearer tok-123');
      expect(captured!['Content-Type'], 'application/json');
    });

    // ── Path 3: bearer absent when no session ───────────────────────────
    test('omits Authorization header when no session is present', () async {
      when(() => auth.currentSession).thenReturn(null);

      Map<String, String>? captured;
      when(
        () => http_.get(
          any(that: predicate<Uri>((u) => u.path.endsWith('/contacts'))),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((invocation) async {
        captured =
            invocation.namedArguments[#headers] as Map<String, String>;
        return http.Response('[]', 200);
      });

      await client.get('/api/v1/contacts');
      expect(captured, isNotNull);
      expect(captured!.containsKey('Authorization'), isFalse);
    });

    // ── Path 4: ApiException mapping for 4xx ────────────────────────────
    test('maps 4xx response to ApiException with error/details fields',
        () async {
      when(
        () => http_.get(
          any(that: predicate<Uri>((u) => u.path.endsWith('/contacts'))),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          jsonEncode({'error': 'validation_failed', 'details': 'name required'}),
          400,
        ),
      );

      final ex = await client
          .get('/api/v1/contacts')
          .then<Object?>((v) => v, onError: (Object e) => e);

      expect(ex, isA<ApiException>());
      final api = ex! as ApiException;
      expect(api.statusCode, 400);
      expect(api.error, 'validation_failed');
      expect(api.details, 'name required');
      expect(api.isClientError, isTrue);
    });

    // ── Path 5: 204 (or empty body) returns null ────────────────────────
    test('returns null on 204 with empty body', () async {
      when(
        () => http_.delete(
          any(
            that: predicate<Uri>((u) => u.path.endsWith('/contacts/c-1')),
          ),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => http.Response('', 204));

      // delete() returns Future<void>; verify it completes without throwing.
      await expectLater(client.delete('/api/v1/contacts/c-1'), completes);
    });
  });
}
