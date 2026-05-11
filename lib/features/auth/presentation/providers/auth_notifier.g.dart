// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotifier)
final authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $StreamNotifierProvider<AuthNotifier, AppUser?> {
  AuthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();
}

String _$authNotifierHash() => r'9643e42f40962856d309eb06be166de536c27c11';

abstract class _$AuthNotifier extends $StreamNotifier<AppUser?> {
  Stream<AppUser?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppUser?>, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppUser?>, AppUser?>,
              AsyncValue<AppUser?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Tracks the transient "just signed up, waiting on email confirmation" state.
///
/// Supabase `signUp()` returns a null session when email confirmation is
/// enabled, so the router would otherwise bounce the user to `/login`.
/// The signup screen calls [mark] right after a successful signUp; the flag
/// auto-clears after [_window] so a stale flag can't trap the user.

@ProviderFor(SignupAwaitingConfirmation)
final signupAwaitingConfirmationProvider =
    SignupAwaitingConfirmationProvider._();

/// Tracks the transient "just signed up, waiting on email confirmation" state.
///
/// Supabase `signUp()` returns a null session when email confirmation is
/// enabled, so the router would otherwise bounce the user to `/login`.
/// The signup screen calls [mark] right after a successful signUp; the flag
/// auto-clears after [_window] so a stale flag can't trap the user.
final class SignupAwaitingConfirmationProvider
    extends $NotifierProvider<SignupAwaitingConfirmation, bool> {
  /// Tracks the transient "just signed up, waiting on email confirmation" state.
  ///
  /// Supabase `signUp()` returns a null session when email confirmation is
  /// enabled, so the router would otherwise bounce the user to `/login`.
  /// The signup screen calls [mark] right after a successful signUp; the flag
  /// auto-clears after [_window] so a stale flag can't trap the user.
  SignupAwaitingConfirmationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupAwaitingConfirmationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupAwaitingConfirmationHash();

  @$internal
  @override
  SignupAwaitingConfirmation create() => SignupAwaitingConfirmation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signupAwaitingConfirmationHash() =>
    r'6d5a3f26c5c81d60ba2d4e07328271fd761df136';

/// Tracks the transient "just signed up, waiting on email confirmation" state.
///
/// Supabase `signUp()` returns a null session when email confirmation is
/// enabled, so the router would otherwise bounce the user to `/login`.
/// The signup screen calls [mark] right after a successful signUp; the flag
/// auto-clears after [_window] so a stale flag can't trap the user.

abstract class _$SignupAwaitingConfirmation extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
