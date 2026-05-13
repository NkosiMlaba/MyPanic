/// GoRouter configuration for app navigation.
library;

///
/// Handles routing between panic states and screens, including authentication.

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:my_panic/features/auth/presentation/providers/auth_notifier.dart';
import 'package:my_panic/features/auth/presentation/screens/login_screen.dart';
import 'package:my_panic/features/auth/presentation/screens/signup_screen.dart';
import 'package:my_panic/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:my_panic/features/auth/presentation/screens/change_password_screen.dart';
import 'package:my_panic/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:my_panic/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/panic/presentation/screens/home_screen.dart';
import 'package:my_panic/features/panic/presentation/screens/countdown_screen.dart';
import 'package:my_panic/features/panic/presentation/screens/alert_active_screen.dart';
import 'package:my_panic/features/panic/domain/panic_state.dart';
import 'package:my_panic/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:my_panic/features/user_profile/presentation/screens/onboarding_screen.dart';
import 'package:my_panic/features/user_profile/presentation/screens/settings_screen.dart';
import 'package:my_panic/features/user_profile/presentation/screens/contacts_screen.dart';
import 'package:my_panic/features/user_profile/presentation/screens/edit_profile_screen.dart';
import 'package:my_panic/features/keychain/presentation/screens/keychain_pairing_screen.dart';

import 'package:my_panic/core/utils/router_logger.dart';

part 'app_router.g.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  static const String onboarding = '/onboarding';
  static const String settings = '/settings';
  static const String contacts = '/contacts';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String countdown = '/countdown';
  static const String alertActive = '/alert-active';
  static const String pairKeychain = '/pair-keychain';
}

/// Provides the GoRouter instance.
@riverpod
GoRouter goRouter(Ref ref) {
  // Watch auth state to trigger redirects
  final authState = ref.watch(authProvider);
  // Transient flag set after signUp when Supabase returns a null session
  // because email confirmation is enabled.
  final awaitingConfirmation = ref.watch(signupAwaitingConfirmationProvider);
  // Transient flag set by AuthLinkHandler when a `type=recovery` deep link
  // lands. The user is now signed in via a recovery-only session that
  // ONLY authorizes updateUser — we must keep them on /reset-password
  // until they pick a new password (or the flag expires).
  final inPasswordRecovery = ref.watch(passwordRecoveryProvider);
  // Watch user profile state
  final userProfileState = ref.watch(userProfileProvider);
  // Watch panic state for panic flow redirects
  final panicState = ref.watch(panicProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    observers: [RouterLogger()],
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isVerified = authState.value?.emailVerified ?? false;

      final userProfile = userProfileState.value;
      // A profile is considered complete if the flag is set OR if the document
      // exists and has a firstName (handles accounts predating the flag).
      final isProfileComplete =
          (userProfile?.isProfileComplete ?? false) ||
          ((userProfile?.firstName ?? '').isNotEmpty);

      final currentPath = state.uri.path;
      final isLoginRoute = currentPath == AppRoutes.login;
      final isSignUpRoute = currentPath == AppRoutes.signup;
      final isForgotPasswordRoute = currentPath == AppRoutes.forgotPassword;
      final isResetPasswordRoute = currentPath == AppRoutes.resetPassword;
      final isVerifyEmailRoute = currentPath == AppRoutes.verifyEmail;
      final isOnboardingRoute = currentPath == AppRoutes.onboarding;

      // 0. Password-recovery short-circuit. Runs BEFORE every other gate so
      // it wins over the "logged in → home" rule below: the recovery session
      // makes Supabase report isLoggedIn=true, but the only safe action is
      // updateUser. The screen calls signOut + clears the flag on success,
      // which collapses this branch back to the normal logged-out flow.
      if (inPasswordRecovery) {
        return isResetPasswordRoute ? null : AppRoutes.resetPassword;
      }

      final isAuthRoute =
          isLoginRoute || isSignUpRoute || isForgotPasswordRoute;

      // 1. If not logged in, force login — except just after signUp when
      // Supabase returns null session (email confirmation enabled).
      // In that case, route to /verify-email so the user knows to check email.
      if (!isLoggedIn) {
        if (awaitingConfirmation && !isVerifyEmailRoute) {
          return AppRoutes.verifyEmail;
        }
        if (awaitingConfirmation && isVerifyEmailRoute) {
          return null;
        }
        return isAuthRoute ? null : AppRoutes.login;
      }

      // 2. If logged in but not verified, force verification
      if (isLoggedIn && !isVerified) {
        return isVerifyEmailRoute ? null : AppRoutes.verifyEmail;
      }

      // 3. User is logged in and verified

      print(
        '[Router] redirect fired. userProfileState runtimeType: ${userProfileState.runtimeType}',
      );
      print(
        '[Router] userProfileState.isLoading: ${userProfileState.isLoading}',
      );
      print('[Router] userProfileState.hasValue: ${userProfileState.hasValue}');
      print(
        '[Router] userProfileState.value: ${userProfileState.value}',
      );
      print('[Router] isProfileComplete: $isProfileComplete');

      // Wait for the profile stream to emit past the initial cache-miss.
      // If the state is AsyncLoading (even if it has no value), we must wait.
      // Firestore streams start in AsyncLoading until the first server or valid cache read.
      if (userProfileState is AsyncLoading) {
        print('[Router] State is AsyncLoading. Waiting...');
        return null;
      }

      // Also wait if we simply have no data yet and it's still loading
      if (userProfileState.isLoading) {
        print('[Router] State isLoading=true. Waiting...');
        return null;
      }

      // If we *have* completed loading, and still have no value, it's a brand new user
      // OR a user who needs to complete the profile.
      // a. Check Profile Completion
      if (isLoggedIn && isVerified && !isProfileComplete) {
        print('[Router] Profile NOT complete. Redirecting to onboarding.');
        return isOnboardingRoute ? null : AppRoutes.onboarding;
      }

      // b. If profile IS complete, prevent access to auth/onboarding routes
      if (isLoggedIn &&
          isVerified &&
          isProfileComplete &&
          (isAuthRoute || isVerifyEmailRoute || isOnboardingRoute)) {
        return AppRoutes.home;
      }

      // 4. Panic State Redirection (Only if authorized and profile set)
      if (panicState is PanicStateCountingDown &&
          currentPath != AppRoutes.countdown) {
        return AppRoutes.countdown;
      }
      if (panicState is PanicStateActive &&
          currentPath != AppRoutes.alertActive) {
        return AppRoutes.alertActive;
      }
      if (panicState is PanicStateArmed &&
          (currentPath == AppRoutes.countdown ||
              currentPath == AppRoutes.alertActive)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.countdown,
        builder: (context, state) => const CountdownScreen(),
      ),
      GoRoute(
        path: AppRoutes.alertActive,
        builder: (context, state) => const AlertActiveScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.contacts,
        builder: (context, state) => const ContactsScreen(),
      ),
      GoRoute(
        path: AppRoutes.pairKeychain,
        builder: (context, state) => const KeychainPairingScreen(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
    ],
  );
}
