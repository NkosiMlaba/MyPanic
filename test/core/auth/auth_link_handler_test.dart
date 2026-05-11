import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/auth/auth_link_handler.dart';

class _MockAppLinks extends Mock implements AppLinks {}

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockAuthSessionUrlResponse extends Mock
    implements AuthSessionUrlResponse {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse('http://x.test'));
  });

  group('AuthLinkHandler', () {
    // ── Path 15: getSessionFromUrl is invoked when an auth-callback URI lands ─
    test(
      'invokes getSessionFromUrl when an auth-callback deep link arrives',
      () async {
        final appLinks = _MockAppLinks();
        final supabase = _MockSupabaseClient();
        final auth = _MockGoTrueClient();
        when(() => supabase.auth).thenReturn(auth);

        final controller = StreamController<Uri>.broadcast();
        when(() => appLinks.uriLinkStream)
            .thenAnswer((_) => controller.stream);

        final captured = <Uri>[];
        when(() => auth.getSessionFromUrl(any())).thenAnswer((invocation) async {
          captured.add(invocation.positionalArguments[0] as Uri);
          return _MockAuthSessionUrlResponse();
        });

        final handler = AuthLinkHandler(appLinks: appLinks, client: supabase);
        handler.start();

        // Non-auth URIs are ignored.
        controller.add(Uri.parse('io.kizuri.mypanic://other'));
        await Future<void>.delayed(Duration.zero);
        verifyNever(() => auth.getSessionFromUrl(any()));

        // Auth-callback URIs go through.
        final cb = Uri.parse(
          'io.kizuri.mypanic://auth-callback?code=abc123',
        );
        controller.add(cb);
        await Future<void>.delayed(Duration.zero);

        expect(captured, [cb]);

        await handler.dispose();
        await controller.close();
      },
    );

    test('swallows getSessionFromUrl errors so the stream stays alive',
        () async {
      final appLinks = _MockAppLinks();
      final supabase = _MockSupabaseClient();
      final auth = _MockGoTrueClient();
      when(() => supabase.auth).thenReturn(auth);

      final controller = StreamController<Uri>.broadcast();
      when(() => appLinks.uriLinkStream).thenAnswer((_) => controller.stream);

      var calls = 0;
      when(() => auth.getSessionFromUrl(any())).thenAnswer((_) async {
        calls++;
        throw StateError('bad code');
      });

      final handler = AuthLinkHandler(appLinks: appLinks, client: supabase);
      handler.start();

      controller.add(Uri.parse('io.kizuri.mypanic://auth-callback?code=x'));
      controller.add(Uri.parse('io.kizuri.mypanic://auth-callback?code=y'));
      await Future<void>.delayed(Duration.zero);

      expect(calls, 2, reason: 'second URI must still be processed');

      await handler.dispose();
      await controller.close();
    });
  });
}
