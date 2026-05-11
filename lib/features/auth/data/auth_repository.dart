import 'dart:developer' as developer;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_panic/features/auth/data/app_user.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(Supabase.instance.client);
}

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  AppUser? _toAppUser(User? u) {
    if (u == null) return null;
    return AppUser(
      id: u.id,
      email: u.email ?? '',
      emailVerified: u.emailConfirmedAt != null,
    );
  }

  /// Emits on every auth state change (sign-in, sign-out, token refresh).
  /// Token-refresh failures are swallowed so they cannot crash the app.
  Stream<AppUser?> get authStateChanges => _client.auth.onAuthStateChange
      .handleError((Object e, StackTrace st) {
        developer.log(
          'authStateChanges error (swallowed)',
          name: 'AuthRepository',
          error: e,
          stackTrace: st,
        );
      })
      .map((event) => _toAppUser(event.session?.user));

  /// Firebase distinguished userChanges (fires on email-verification etc.)
  /// from authStateChanges. Supabase doesn't expose a perfect equivalent;
  /// onAuthStateChange covers our use cases.
  Stream<AppUser?> get userChanges => authStateChanges;

  AppUser? get currentUser => _toAppUser(_client.auth.currentUser);

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _client.auth.signUp(email: email, password: password);
  }

  /// Supabase emails the reset link. The redirect URL is configured in
  /// Supabase Studio → Authentication → URL Configuration.
  Future<void> sendPasswordResetEmail(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// No direct reauthenticate-with-credentials API in Supabase; re-call
  /// signInWithPassword. Throws on bad password.
  Future<void> reauthenticate(String password) async {
    final email = currentUser?.email;
    if (email == null || email.isEmpty) {
      throw StateError('No user signed in');
    }
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// Resend the signup confirmation email. Used by verify_email_screen.
  Future<void> resendSignupConfirmation(String email) async {
    await _client.auth.resend(type: OtpType.signup, email: email);
  }

  /// Refresh the session; useful while polling for email verification.
  Future<void> refreshSession() async {
    await _client.auth.refreshSession();
  }
}
