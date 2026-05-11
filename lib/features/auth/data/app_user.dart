/// App-level user value type. Replaces firebase_auth.User so consumers don't
/// import auth-provider types directly.
class AppUser {
  /// Supabase Auth user UUID. Matches Profile.auth_user_id on the server
  /// (NOT Profile.id, which is an internal UUID per backend addendum #17).
  /// Flutter code never sends a profile id; the API resolves "me" from the JWT.
  final String id;
  final String email;
  final bool emailVerified;

  const AppUser({
    required this.id,
    required this.email,
    required this.emailVerified,
  });
}
