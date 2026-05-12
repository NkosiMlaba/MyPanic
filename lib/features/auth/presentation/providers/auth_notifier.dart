import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/features/auth/data/app_user.dart';
import 'package:my_panic/features/auth/data/auth_repository.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Stream<AppUser?> build() {
    return ref.watch(authRepositoryProvider).userChanges;
  }
}

/// Tracks the transient "just signed up, waiting on email confirmation" state.
///
/// Supabase `signUp()` returns a null session when email confirmation is
/// enabled, so the router would otherwise bounce the user to `/login`.
/// The signup screen calls [mark] right after a successful signUp; the flag
/// auto-clears after [_window] so a stale flag can't trap the user.
@Riverpod(keepAlive: true)
class SignupAwaitingConfirmation extends _$SignupAwaitingConfirmation {
  static const _window = Duration(seconds: 30);
  Timer? _expiry;

  @override
  bool build() {
    ref.onDispose(() => _expiry?.cancel());
    return false;
  }

  void mark() {
    _expiry?.cancel();
    state = true;
    _expiry = Timer(_window, () {
      if (state) state = false;
    });
  }

  void clear() {
    _expiry?.cancel();
    if (state) state = false;
  }
}

/// Tracks the transient "password recovery in progress" state.
///
/// Set by [AuthLinkHandler] when it detects a `type=recovery` deep link, BEFORE
/// it calls `getSessionFromUrl`. The router watches this flag and force-routes
/// to `/reset-password` even though Supabase will report the user as logged in
/// — the recovery session is special-purpose (only authorizes `updateUser`),
/// so we should not let the user wander into the rest of the app.
///
/// Cleared by `/reset-password` after a successful update + signOut, or after
/// [_window] elapses if the user abandons the flow.
@Riverpod(keepAlive: true)
class PasswordRecovery extends _$PasswordRecovery {
  static const _window = Duration(minutes: 5);
  Timer? _expiry;

  @override
  bool build() {
    ref.onDispose(() => _expiry?.cancel());
    return false;
  }

  void mark() {
    _expiry?.cancel();
    state = true;
    _expiry = Timer(_window, () {
      if (state) state = false;
    });
  }

  void clear() {
    _expiry?.cancel();
    if (state) state = false;
  }
}
