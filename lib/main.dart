/// MYPanic - Student Safety App
library;

///
/// MVP Phase 1: Manual Panic Button

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/core/router/app_router.dart';

import 'package:my_panic/core/utils/riverpod_logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // Note: asking user to provide google-services.json, so we use DefaultFirebaseOptions if available,
  // or fall back to platform default (which uses google-services.json on Android).
  // For now, valid android setup relies on google-services.json being present.
  await Firebase.initializeApp();

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
