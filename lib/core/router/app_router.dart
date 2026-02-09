/// GoRouter configuration for app navigation.
library;

///
/// Handles routing between panic states and screens.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/panic/presentation/screens/home_screen.dart';
import 'package:my_panic/features/panic/presentation/screens/countdown_screen.dart';
import 'package:my_panic/features/panic/presentation/screens/alert_active_screen.dart';

part 'app_router.g.dart';

/// Route paths
class AppRoutes {
  static const String home = '/';
  static const String countdown = '/countdown';
  static const String alertActive = '/alert-active';
}

/// Provides the GoRouter instance.
@riverpod
GoRouter goRouter(Ref ref) {
  final panicState = ref.watch(panicNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // Redirect based on panic state
      return panicState.when(
        idle: () => null,
        armed: () {
          // If on countdown or alert, go back to home
          if (currentPath == AppRoutes.countdown ||
              currentPath == AppRoutes.alertActive) {
            return AppRoutes.home;
          }
          return null;
        },
        countingDown: (_, _) {
          // Navigate to countdown screen
          if (currentPath != AppRoutes.countdown) {
            return AppRoutes.countdown;
          }
          return null;
        },
        active: (_, _) {
          // Navigate to alert active screen
          if (currentPath != AppRoutes.alertActive) {
            return AppRoutes.alertActive;
          }
          return null;
        },
        cancelled: (_) {
          // Stay on current or go home
          if (currentPath == AppRoutes.countdown ||
              currentPath == AppRoutes.alertActive) {
            return AppRoutes.home;
          }
          return null;
        },
        error: (_, _) => null,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.countdown,
        builder: (context, state) => const CountdownScreen(),
      ),
      GoRoute(
        path: AppRoutes.alertActive,
        builder: (context, state) => const AlertActiveScreen(),
      ),
    ],
  );
}
