/// Alert active screen (stealth mode).
library;

///
/// Shown when the emergency alert has been sent.
/// Dark/minimal design for discretion.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/user_profile/presentation/providers/contacts_provider.dart';
import 'package:my_panic/features/user_profile/presentation/providers/medical_profile_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
                        color: AppTheme.successGreen.withValues(alpha: 0.15),
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

                    // Medical Info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Consumer(
                        builder: (context, ref, child) {
                          final profile = ref.watch(medicalProfileProvider);
                          if (profile == null) {
                            return const SizedBox.shrink(); // Hide if no profile
                          }
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.errorRed.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MEDICAL INFO (Show to EMS)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.errorRed,
                                    letterSpacing: 1,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoItem(
                                      'Blood Type',
                                      profile.bloodType ?? 'Unknown',
                                    ),
                                    _buildInfoItem(
                                      'Allergies',
                                      profile.allergies.isNotEmpty
                                          ? profile.allergies.join(', ')
                                          : 'None',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildInfoItem(
                                  'Conditions',
                                  profile.conditions.isNotEmpty
                                      ? profile.conditions.join(', ')
                                      : 'None',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Emergency contacts list (real)
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final contactsAsync = ref.watch(contactsListProvider);

                          return contactsAsync.when(
                            data: (contacts) {
                              if (contacts.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No contacts notified',
                                    style: TextStyle(color: AppTheme.textMuted),
                                  ),
                                );
                              }
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Column(
                                    children: contacts
                                        .map(
                                          (contact) => _buildContactRow(
                                            contact.name,
                                            contact.phone,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryRed,
                              ),
                            ),
                            error: (_, __) => const Text(
                              'Error loading contacts',
                              style: TextStyle(color: AppTheme.errorRed),
                            ),
                          );
                        },
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
                  color: AppTheme.textMuted.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppTheme.textSecondary.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(String name, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'Notified',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.successGreen.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.call, color: AppTheme.successGreen),
            onPressed: () async {
              final uri = Uri(scheme: 'tel', path: phone);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
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

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
              color: AppTheme.successGreen.withValues(alpha: 0.1),
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
