/// Home screen with panic button.
library;

///
/// Main screen of the app showing the large panic button.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/domain/panic_state.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/panic/presentation/widgets/panic_button_widget.dart';

/// Home screen with the main panic button.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panicState = ref.watch(panicNotifierProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MYPanic',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Student Safety',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildStatusIndicator(panicState),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        color: AppTheme.textSecondary,
                        onPressed: () {
                          // TODO: Navigate to settings
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppTheme.successGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'System Armed',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'Press the button below in case of emergency',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Panic Button (centered)
            const Expanded(child: Center(child: PanicButtonWidget())),

            // Bottom info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoChip(
                        icon: Icons.people_outline,
                        label: '5 Contacts',
                      ),
                      const SizedBox(width: 12),
                      _buildInfoChip(
                        icon: Icons.location_on_outlined,
                        label: 'GPS Active',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '30 second countdown before alert is sent',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(PanicState state) {
    return state.when(
      idle: () => _statusDot(AppTheme.textMuted, 'Idle'),
      armed: () => _statusDot(AppTheme.successGreen, 'Ready'),
      countingDown: (_, _) => _statusDot(AppTheme.warningYellow, 'Counting'),
      active: (_, _) => _statusDot(AppTheme.errorRed, 'Active'),
      cancelled: (_) => _statusDot(AppTheme.infoBlue, 'Cancelled'),
      error: (_, _) => _statusDot(AppTheme.errorRed, 'Error'),
    );
  }

  Widget _statusDot(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.cardDark, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppTheme.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
