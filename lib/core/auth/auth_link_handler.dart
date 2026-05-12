import 'dart:async';
import 'dart:developer' as developer;

import 'package:app_links/app_links.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Listens for deep links matching the PKCE auth-callback URI and completes
/// the Supabase auth flow. Without this, password-reset and email-confirmation
/// links open in the browser and the app never receives the session.
///
/// Expected URI shape: `io.kizuri.mypanic://auth-callback?code=...`
///
/// For password-recovery URIs (`?type=recovery`), the handler invokes
/// [onRecoveryDetected] BEFORE calling `getSessionFromUrl`. The router watches
/// the resulting flag (set by main.dart's wiring) to force-route to
/// `/reset-password` rather than letting the recovery session land the user
/// on `/home` — the recovery session only authorizes `updateUser`.
class AuthLinkHandler {
  AuthLinkHandler({
    AppLinks? appLinks,
    SupabaseClient? client,
    void Function()? onRecoveryDetected,
  })  : _appLinks = appLinks ?? AppLinks(),
        _client = client ?? Supabase.instance.client,
        _onRecoveryDetected = onRecoveryDetected;

  final AppLinks _appLinks;
  final SupabaseClient _client;
  final void Function()? _onRecoveryDetected;
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

    // Mark recovery flag BEFORE we exchange the code. The
    // onAuthStateChange `passwordRecovery` event lands inside
    // getSessionFromUrl; if the flag isn't set yet, the router rebuilds
    // briefly with isLoggedIn=true + flag=false and pushes the user to
    // /home before the flag arrives.
    if (_isRecoveryUri(uri)) {
      _onRecoveryDetected?.call();
    }

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

  /// Supabase encodes the link kind as `type=recovery|signup|magiclink|...`
  /// in the query. We check both query param and fragment because some
  /// flows route the params under `#` instead of `?`.
  static bool _isRecoveryUri(Uri uri) {
    if (uri.queryParameters['type'] == 'recovery') return true;
    final fragment = uri.fragment;
    if (fragment.isEmpty) return false;
    final fragParams = Uri.splitQueryString(fragment);
    return fragParams['type'] == 'recovery';
  }
}
