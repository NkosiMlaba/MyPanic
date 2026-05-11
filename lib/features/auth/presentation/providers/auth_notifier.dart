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
