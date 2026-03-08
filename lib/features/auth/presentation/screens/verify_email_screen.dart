import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/auth/data/auth_repository.dart';
import 'package:my_panic/features/auth/presentation/providers/auth_notifier.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? _timer;
  bool _canResendEmail = false;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null && !user.emailVerified) {
      user.sendEmailVerification();
    }

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _checkEmailVerified(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = authRepo.currentUser;

    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        _timer?.cancel();
        if (mounted) {
          ref.invalidate(authNotifierProvider);
        }
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() => _canResendEmail = false);
        await Future.delayed(const Duration(seconds: 5));
        if (mounted) setState(() => _canResendEmail = true);
      }
    } catch (e) {
      debugPrint('Error resending email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/MyPanic-logo-heart.png', height: 100),
            const SizedBox(height: 24),
            const Text(
              'Verify your email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textBrandPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'We have sent a verification link to your email address. Please verify your account to continue.',
              style: TextStyle(color: AppTheme.textBrandSecondary, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppTheme.brandPink),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _canResendEmail ? _resendVerificationEmail : null,
              icon: const Icon(Icons.email),
              label: const Text('Resend Email'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).signOut();
              },
              child: const Text('Cancel / Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
