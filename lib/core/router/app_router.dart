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

part 'app_router.g.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';
  static const String onboarding = '/onboarding';
  static const String settings = '/settings';
  static const String contacts = '/contacts';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String countdown = '/countdown';
  static const String alertActive = '/alert-active';
}

/// Provides the GoRouter instance.
@riverpod
GoRouter goRouter(Ref ref) {
  // Watch auth state to trigger redirects
  final authState = ref.watch(authNotifierProvider);
  // Watch user profile state
  final userProfileState = ref.watch(userProfileProvider);
  // Watch panic state for panic flow redirects
  final panicState = ref.watch(panicNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isVerified = authState.valueOrNull?.emailVerified ?? false;

      final userProfile = userProfileState.valueOrNull;
      final isProfileComplete = userProfile?.isProfileComplete ?? false;

      final currentPath = state.uri.path;
      final isLoginRoute = currentPath == AppRoutes.login;
      final isSignUpRoute = currentPath == AppRoutes.signup;
      final isForgotPasswordRoute = currentPath == AppRoutes.forgotPassword;
      final isVerifyEmailRoute = currentPath == AppRoutes.verifyEmail;
      final isOnboardingRoute = currentPath == AppRoutes.onboarding;

      final isAuthRoute =
          isLoginRoute || isSignUpRoute || isForgotPasswordRoute;

      // 1. If not logged in, force login (unless on an auth route)
      if (!isLoggedIn) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      // 2. If logged in but not verified, force verification
      if (isLoggedIn && !isVerified) {
        return isVerifyEmailRoute ? null : AppRoutes.verifyEmail;
      }

      // 3. User is logged in and verified

      // a. Check Profile Completion
      // If profile is NOT complete, force onboarding
      // Note: We check if userProfileState is loading to avoid premature redirect?
      // Actually, if value is null, it might mean loading or no profile.
      // Firestore returns null if doc doesn't exist.
      // So if (isLoggedIn && isVerified && !isProfileComplete) -> Onboarding
      if (isLoggedIn && isVerified && !isProfileComplete) {
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
