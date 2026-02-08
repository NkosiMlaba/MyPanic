/// Alert active screen (stealth mode).
///
/// Shown when the emergency alert has been sent.
/// Dark/minimal design for discretion.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';

/// Alert active screen with "Help is on the way" message.
class AlertActiveScreen extends ConsumerWidget {
  const AlertActiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Very subtle header (stealth mode)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppTheme.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      _showResetConfirmation(context, ref);
                    },
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pulsing icon
                    _PulsingIcon(),

                    const SizedBox(height: 32),

                    // Main message
                    const Text(
                      'Help is on the way',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w300,
                        color: AppTheme.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Status
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: AppTheme.successGreen,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Alert sent to 5 contacts',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Emergency contacts list (minimal)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Column(
                        children: [
                          _buildContactRow('Mom', 'Notified'),
                          _buildContactRow('Dad', 'Notified'),
                          _buildContactRow('Campus Security', 'Notified'),
                          _buildContactRow('Best Friend', 'Notified'),
                          _buildContactRow('Resident Advisor', 'Notified'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom info (very subtle)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Stay safe. Help has been alerted.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String name, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.successGreen.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        title: const Text(
          'Reset System?',
          style: TextStyle(color: AppTheme.textPrimary),
        ),
        content: const Text(
          'This will reset the panic system. Only do this if you are safe.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(panicNotifierProvider.notifier).reset();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
            ),
            child: const Text('I\'m Safe'),
          ),
        ],
      ),
    );
  }
}

/// Pulsing icon animation widget.
class _PulsingIcon extends StatefulWidget {
  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.successGreen.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.shield_outlined,
              size: 64,
              color: AppTheme.successGreen,
            ),
          ),
        );
      },
    );
  }
}
