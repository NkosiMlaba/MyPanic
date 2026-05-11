/// Mapped HTTP error response from the MyPanic API.
///
/// `error` is the machine-readable error code from the API body (e.g.
/// `validation_failed`, `forbidden`, `auth_misconfigured`). `details` is
/// the human-readable message, when one is available.
class ApiException implements Exception {
  final int statusCode;
  final String? error;
  final String? details;
  final String requestPath;

  ApiException(
    this.statusCode,
    this.requestPath, {
    this.error,
    this.details,
  });

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;

  /// True when the misconfig probe at first-instantiation surfaced a 401
  /// while no session was present — pretty much always a missing
  /// `MYPANIC_API_BASE_URL` or `SUPABASE_*` dart-define on the dev machine.
  bool get isAuthMisconfigured => error == 'auth_misconfigured';

  @override
  String toString() =>
      'ApiException($statusCode $requestPath): ${error ?? ''} ${details ?? ''}';
}
