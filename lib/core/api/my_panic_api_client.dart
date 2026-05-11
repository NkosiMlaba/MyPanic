import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/api_options.dart';

part 'my_panic_api_client.g.dart';

@Riverpod(keepAlive: true)
MyPanicApiClient myPanicApiClient(Ref ref) {
  final client = MyPanicApiClient(
    http.Client(),
    Supabase.instance.client,
  );
  ref.onDispose(client.dispose);
  return client;
}

/// Thin typed wrapper around `package:http` that:
///   * attaches the Supabase access token to every request
///   * decodes JSON responses
///   * maps non-2xx responses to [ApiException]
///   * retries once after a 401 if a refresh token is available
///   * probes `/health` once at construction to distinguish a misconfigured
///     dev environment from a normal logged-out 401
class MyPanicApiClient {
  final http.Client _http;
  final SupabaseClient _supabase;

  static const _timeout = Duration(seconds: 10);

  /// Sentinel header — set on the second leg of a 401-retry so the decoder
  /// knows not to recurse forever. Internal only; never sent over the wire.
  static const _retryMarker = '__mypanic_retry__';

  bool _healthProbed = false;

  MyPanicApiClient(this._http, this._supabase);

  // ── Public API ──────────────────────────────────────────────────────────

  Future<dynamic> get(String path) => _send('GET', path, null);

  Future<dynamic> put(String path, Object body) => _send('PUT', path, body);

  Future<dynamic> post(String path, Object? body) => _send('POST', path, body);

  Future<void> delete(String path) async {
    await _send('DELETE', path, null);
  }

  void dispose() {
    _http.close();
  }

  // ── Internals ───────────────────────────────────────────────────────────

  Map<String, String> _headers({bool isRetry = false}) {
    final token = _supabase.auth.currentSession?.accessToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (isRetry) _retryMarker: '1',
    };
  }

  /// Override #17: use `Uri.resolveUri` so trailing slashes on the base URL
  /// and leading slashes on the path compose correctly.
  Uri _uri(String path) {
    final base = Uri.parse(ApiOptions.apiBaseUrl);
    final stripped = path.startsWith('/') ? path.substring(1) : path;
    return base.resolveUri(Uri.parse(stripped));
  }

  Future<dynamic> _send(String method, String path, Object? body) async {
    await _maybeProbeHealth();
    return _sendOnce(method, path, body, isRetry: false);
  }

  Future<dynamic> _sendOnce(
    String method,
    String path,
    Object? body, {
    required bool isRetry,
  }) async {
    final uri = _uri(path);
    final headers = _headers(isRetry: isRetry);
    final encoded = body == null ? null : jsonEncode(body);

    http.Response resp;
    try {
      switch (method) {
        case 'GET':
          resp = await _http.get(uri, headers: headers).timeout(_timeout);
        case 'PUT':
          resp = await _http
              .put(uri, headers: headers, body: encoded)
              .timeout(_timeout);
        case 'POST':
          resp = await _http
              .post(uri, headers: headers, body: encoded)
              .timeout(_timeout);
        case 'DELETE':
          resp = await _http.delete(uri, headers: headers).timeout(_timeout);
        default:
          throw StateError('Unsupported HTTP method: $method');
      }
    } on TimeoutException {
      throw ApiException(
        408,
        path,
        error: 'timeout',
        details: 'Request exceeded ${_timeout.inSeconds}s',
      );
    }

    // Override #4: 401-retry-once. Only retry if we have a refresh token
    // and we're not already on the retry leg.
    if (resp.statusCode == 401 &&
        !isRetry &&
        _supabase.auth.currentSession?.refreshToken != null) {
      try {
        await _supabase.auth.refreshSession();
        return _sendOnce(method, path, body, isRetry: true);
      } catch (e, st) {
        developer.log(
          'refreshSession failed during 401-retry for $path',
          name: 'MyPanicApiClient',
          error: e,
          stackTrace: st,
        );
        // Fall through and let the original 401 propagate.
      }
    }

    return _decode(path, resp);
  }

  dynamic _decode(String path, http.Response resp) {
    if (resp.statusCode == 204 || resp.body.isEmpty) {
      if (resp.statusCode >= 400) {
        throw ApiException(resp.statusCode, path);
      }
      return null;
    }
    final dynamic decoded;
    try {
      decoded = jsonDecode(resp.body);
    } catch (_) {
      if (resp.statusCode >= 400) {
        throw ApiException(
          resp.statusCode,
          path,
          details: resp.body,
        );
      }
      rethrow;
    }
    if (resp.statusCode >= 400) {
      String? err;
      String? det;
      if (decoded is Map) {
        err = decoded['error'] as String?;
        det = decoded['details'] as String? ?? decoded['message'] as String?;
      }
      throw ApiException(resp.statusCode, path, error: err, details: det);
    }
    return decoded;
  }

  /// Override #16: probe `/health` once. If the server returns 401 while we
  /// have no session, that's almost always a misconfigured base URL or anon
  /// key pointing at an auth-gated endpoint — surface it loudly rather than
  /// letting every downstream call fail mysteriously.
  Future<void> _maybeProbeHealth() async {
    if (_healthProbed) return;
    _healthProbed = true;
    try {
      final resp = await _http
          .get(_uri('/health'), headers: _headers())
          .timeout(_timeout);
      if (resp.statusCode == 401 && _supabase.auth.currentSession == null) {
        throw ApiException(
          401,
          '/health',
          error: 'auth_misconfigured',
          details:
              'The API returned 401 on /health with no session. Check '
              'MYPANIC_API_BASE_URL points at the public API, not an '
              'auth-gated endpoint.',
        );
      }
    } on ApiException {
      rethrow;
    } catch (e, st) {
      // Network failure on the probe is fine — caller will see it on the
      // real request. We just don't want to mask it as a misconfig.
      developer.log(
        '/health probe failed (non-fatal)',
        name: 'MyPanicApiClient',
        error: e,
        stackTrace: st,
      );
    }
  }
}
