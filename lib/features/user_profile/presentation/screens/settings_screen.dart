import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_panic/core/router/app_router.dart';
import 'package:my_panic/core/services/permission_service.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/auth/data/auth_repository.dart';
import 'package:my_panic/features/trigger_engine/shake_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/trigger_settings_provider.dart';
import 'package:my_panic/features/user_profile/presentation/providers/settings_provider.dart';
import 'package:my_panic/features/user_profile/presentation/providers/user_profile_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider).value;

    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        children: [
          if (userProfile != null) ...[
            _buildProfileHeader(userProfile.firstName, userProfile.lastName),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader('Account'),
          _buildSettingsTile(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Name, phone, and medical info',
            onTap: () => context.push(AppRoutes.editProfile),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.contact_phone_outlined,
            title: 'Emergency Contacts',
            subtitle: 'Manage who to notify',
            onTap: () => context.push(AppRoutes.contacts),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.bluetooth_outlined,
            title: 'Pair Panic Keychain',
            subtitle: 'Connect an ESP32 keychain for hands-free alerts',
            onTap: () => context.push(AppRoutes.pairKeychain),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Safety'),
          Consumer(
            builder: (context, ref, child) {
              final duration = ref.watch(settingsProvider);
              return ListTile(
                leading: const Icon(Icons.timer_outlined),
                title: const Text('Countdown Duration', style: TextStyle(fontSize: 16)),
                subtitle: const Text(
                  'Time before alert is sent',
                  style: TextStyle(color: AppTheme.textBrandSecondary),
                ),
                trailing: DropdownButton<int>(
                  value: duration,
                  dropdownColor: AppTheme.surfaceBrand,
                  style: const TextStyle(color: AppTheme.textBrandPrimary),
                  underline: const SizedBox(),
                  items: [10, 30, 60].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value sec'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      ref
                          .read(settingsProvider.notifier)
                          .setCountdownDuration(val);
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Trigger Methods'),
          _buildTriggerSettings(context, ref),
          const SizedBox(height: 24),
          _buildSectionHeader('Security'),
          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          const Divider(color: AppTheme.dividerBrand, height: 32),
          _buildSettingsTile(
            context,
            icon: Icons.logout,
            title: 'Sign Out',
            color: AppTheme.brandPink,
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppTheme.surfaceBrand,
                  title: const Text(
                    'Sign Out?',
                    style: TextStyle(color: AppTheme.textBrandPrimary),
                  ),
                  content: const Text(
                    'Are you sure you want to sign out?',
                    style: TextStyle(color: AppTheme.textBrandSecondary),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(color: AppTheme.brandPink),
                      ),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await ref.read(authRepositoryProvider).signOut();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String firstName, String lastName) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.brandPinkLight,
          child: Text(
            firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.brandPink,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '$firstName $lastName',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textBrandPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textBrandMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTriggerSettings(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(triggerSettingsProvider);
    final notifier = ref.read(triggerSettingsProvider.notifier);

    return Column(
      children: [
        // Notification Panic Button
        if (Platform.isAndroid)
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text(
              'Notification Panic Button',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Persistent notification with emergency button',
              style: TextStyle(color: AppTheme.textBrandSecondary),
            ),
            value: settings.notificationTriggerEnabled,
            activeThumbColor: AppTheme.brandPink,
            onChanged: (value) async {
              if (value) {
                final permService = PermissionService();
                final granted =
                    await permService.requestNotificationPermission();
                if (!granted) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Notification permission is required for this feature',
                        ),
                      ),
                    );
                  }
                  return;
                }
              }
              notifier.setNotificationTriggerEnabled(value);
            },
          ),

        // Shake to Panic
        SwitchListTile(
          secondary: const Icon(Icons.vibration),
          title: const Text(
            'Shake to Panic',
            style: TextStyle(fontSize: 16),
          ),
          subtitle: const Text(
            'Shake your phone vigorously to trigger panic',
            style: TextStyle(color: AppTheme.textBrandSecondary),
          ),
          value: settings.shakeTriggerEnabled,
          activeThumbColor: AppTheme.brandPink,
          onChanged: (value) => notifier.setShakeTriggerEnabled(value),
        ),

        // Shake Sensitivity (only visible when shake is enabled)
        if (settings.shakeTriggerEnabled)
          ListTile(
            leading: const SizedBox(width: 24), // indent to align with toggles
            title: const Text(
              'Shake Sensitivity',
              style: TextStyle(fontSize: 16),
            ),
            trailing: DropdownButton<ShakeSensitivity>(
              value: settings.shakeSensitivity,
              dropdownColor: AppTheme.surfaceBrand,
              style: const TextStyle(color: AppTheme.textBrandPrimary),
              underline: const SizedBox(),
              items: ShakeSensitivity.values.map((s) {
                final label = switch (s) {
                  ShakeSensitivity.low => 'Low',
                  ShakeSensitivity.medium => 'Medium',
                  ShakeSensitivity.high => 'High',
                };
                return DropdownMenuItem(value: s, child: Text(label));
              }).toList(),
              onChanged: (val) {
                if (val != null) notifier.setShakeSensitivity(val);
              },
            ),
          ),

        // Quick Settings Tile (Android only, informational)
        if (Platform.isAndroid)
          SwitchListTile(
            secondary: const Icon(Icons.dashboard_customize_outlined),
            title: const Text(
              'Quick Settings Tile',
              style: TextStyle(fontSize: 16),
            ),
            subtitle: const Text(
              'Add MyPanic to your Quick Settings panel',
              style: TextStyle(color: AppTheme.textBrandSecondary),
            ),
            value: settings.qsTileTriggerEnabled,
            activeThumbColor: AppTheme.brandPink,
            onChanged: (value) => notifier.setQSTileTriggerEnabled(value),
          ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color color = AppTheme.textBrandPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: AppTheme.textBrandSecondary))
          : null,
      trailing: Icon(Icons.chevron_right, color: AppTheme.dividerBrand),
      onTap: onTap,
    );
  }
}
