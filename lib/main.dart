/// MYPanic - Student Safety App
library;

///
/// MVP Phase 1: Manual Panic Button

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_panic/core/api/api_options.dart';
import 'package:my_panic/core/auth/auth_link_handler.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/core/router/app_router.dart';

import 'package:my_panic/core/utils/riverpod_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Validate config — fail fast if --dart-define values are missing.
  ApiOptions.assertConfigured();

  await Supabase.initialize(
    url: ApiOptions.supabaseUrl,
    anonKey: ApiOptions.supabaseAnonKey,
    // Persist session in shared_preferences (already a dep)
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // Override #5: validate session at boot. If a persisted session exists
  // but is expired, try a refresh; on failure, sign out cleanly so the
  // app starts in the logged-out state instead of with stale creds.
  final session = Supabase.instance.client.auth.currentSession;
  if (session != null && session.isExpired) {
    try {
      await Supabase.instance.client.auth.refreshSession();
    } catch (_) {
      await Supabase.instance.client.auth.signOut();
    }
  }

  // Override #14 / Task 4d: handle PKCE deep-links (password-reset,
  // email-confirmation). The handler must outlive any one screen, so we
  // hold the reference on a long-lived top-level field.
  _authLinkHandler = AuthLinkHandler()..start();

  // Lock to portrait mode for consistent UX
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.backgroundBrand,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(
    ProviderScope(observers: [RiverpodLogger()], child: const MyPanicApp()),
  );
}

// Holds the lifetime-of-app deep-link subscription so it isn't GC'd.
// ignore: unused_element
AuthLinkHandler? _authLinkHandler;

/// Main application widget.
class MyPanicApp extends ConsumerWidget {
  const MyPanicApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'MyPanic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.brandTheme,
      routerConfig: router,
    );
  }
}
