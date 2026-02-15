/// Countdown screen shown during panic countdown.
library;

///
/// Shows timer, progress bar, and cancel option.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';

import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/user_profile/presentation/providers/settings_provider.dart';

/// Countdown screen with timer and cancel option.
class CountdownScreen extends ConsumerWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panicState = ref.watch(panicNotifierProvider);

    // Get seconds remaining from state
    final secondsRemaining = panicState.maybeWhen(
      countingDown: (seconds, _) => seconds,
      orElse: () => 0,
    );

    final totalDuration = ref.watch(settingsProvider);
    final progress = secondsRemaining / totalDuration;

    return Scaffold(
      backgroundColor: const Color(0xFF1A0A0A), // Dark red tinted background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningYellow.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.warningYellow,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'EMERGENCY COUNTDOWN',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.warningYellow,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Timer
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Circular progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background circle
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: 1,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.errorRed.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        // Progress circle
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 8,
                            backgroundColor: Colors.transparent,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppTheme.errorRed,
                            ),
                          ),
                        ),
                        // Timer text
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              secondsRemaining.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                fontSize: 96,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const Text(
                              'SECONDS',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.textSecondary,
                                letterSpacing: 4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // Info text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        'Alert will be sent to your emergency contacts when timer reaches zero',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cancel button
            Padding(
              padding: const EdgeInsets.all(32),
              child: _SlideToCancel(
                onCancel: () {
                  ref.read(panicNotifierProvider.notifier).cancelPanic();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slide to cancel widget.
class _SlideToCancel extends StatefulWidget {
  final VoidCallback onCancel;

  const _SlideToCancel({required this.onCancel});

  @override
  State<_SlideToCancel> createState() => _SlideToCancelState();
}

class _SlideToCancelState extends State<_SlideToCancel> {
  double _dragPosition = 0;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final maxDrag = MediaQuery.of(context).size.width - 32 - 80 - 64;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppTheme.errorRed.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Background text
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textMuted.withValues(alpha: 0.5),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textMuted.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'SLIDE TO CANCEL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textMuted.withValues(alpha: 0.5),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppTheme.textMuted.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),
          // Slider thumb
          Positioned(
            left: 4 + _dragPosition,
            top: 4,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (_confirmed) return;
                setState(() {
                  _dragPosition += details.delta.dx;
                  _dragPosition = _dragPosition.clamp(0, maxDrag);

                  if (_dragPosition >= maxDrag * 0.9) {
                    _confirmed = true;
                    widget.onCancel();
                  }
                });
              },
              onHorizontalDragEnd: (details) {
                if (!_confirmed) {
                  setState(() {
                    _dragPosition = 0;
                  });
                }
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _confirmed
                      ? AppTheme.successGreen
                      : AppTheme.surfaceDark,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _confirmed
                        ? AppTheme.successGreen
                        : AppTheme.errorRed.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _confirmed ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
