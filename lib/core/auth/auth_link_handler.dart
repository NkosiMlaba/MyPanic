import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Listens for deep links matching the PKCE auth-callback URI and completes
/// the Supabase auth flow. Without this, password-reset and email-confirmation
/// links open in the browser and the app never receives the session.
///
/// Expected URI shape: `io.kizuri.mypanic://auth-callback?code=...`
class AuthLinkHandler {
  AuthLinkHandler({AppLinks? appLinks, SupabaseClient? client})
      : _appLinks = appLinks ?? AppLinks(),
        _client = client ?? Supabase.instance.client;

  final AppLinks _appLinks;
  final SupabaseClient _client;
  StreamSubscription<Uri>? _sub;

  /// Subscribe to incoming deep links. Safe to call once at app boot.
  void start() {
    _sub?.cancel();
    _sub = _appLinks.uriLinkStream.listen(
      _handle,
      onError: (Object e, StackTrace st) {
        developer.log(
          'auth deep-link stream error',
          name: 'AuthLinkHandler',
          error: e,
          stackTrace: st,
        );
      },
    );
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> _handle(Uri uri) async {
    if (!uri.toString().contains('auth-callback')) return;
    try {
      await _client.auth.getSessionFromUrl(uri);
    } catch (e, st) {
      developer.log(
        'getSessionFromUrl failed for $uri',
        name: 'AuthLinkHandler',
        error: e,
        stackTrace: st,
      );
    }
  }
}
