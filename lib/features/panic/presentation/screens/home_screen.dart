/// Home screen with panic button.
library;

///
/// Main screen of the app showing the large panic button.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_panic/core/router/app_router.dart';
import 'package:my_panic/core/services/location_service.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/domain/panic_state.dart';
import 'package:my_panic/features/panic/presentation/providers/panic_notifier.dart';
import 'package:my_panic/features/panic/presentation/widgets/panic_button_widget.dart';
import 'package:my_panic/features/user_profile/presentation/providers/contacts_provider.dart';
import 'package:my_panic/features/user_profile/presentation/providers/settings_provider.dart';

/// Home screen with the main panic button.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    final locationService = ref.read(locationServiceProvider);

    final serviceEnabled = await locationService.isServiceEnabled();
    if (!serviceEnabled && mounted) {
      _showLocationDialog(
        'Location Services Disabled',
        'Please enable location services to use the panic button effectively.',
      );
      return;
    }

    final hasPermission = await locationService.hasPermission();
    if (!hasPermission && mounted) {
      final request = await locationService.requestPermission();
      if (!request && mounted) {
        _showLocationDialog(
          'Location Permission Needed',
          'We need your location to send emergency alerts. Please grant permission.',
        );
      }
    }
  }

  void _showLocationDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceBrand,
        title: Text(title, style: const TextStyle(color: AppTheme.textBrandPrimary)),
        content: Text(
          message,
          style: const TextStyle(color: AppTheme.textBrandSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panicState = ref.watch(panicProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/MyPanic-logo-heart.png',
                        height: 36,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MyPanic',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textBrandPrimary,
                            ),
                          ),
                          Text(
                            'Stay Loud. Stay Safe.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.brandPink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildStatusIndicator(panicState),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        color: AppTheme.textBrandSecondary,
                        onPressed: () {
                          context.push(AppRoutes.settings);
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
                  color: AppTheme.cardBrand,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.dividerBrand),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.15),
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
                              color: AppTheme.textBrandPrimary,
                            ),
                          ),
                          Text(
                            'Press the button below in case of emergency',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textBrandSecondary,
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
            _buildBottomInfo(ref),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(PanicState state) {
    return state.when(
      idle: () => _statusDot(AppTheme.textBrandMuted, 'Idle'),
      armed: () => _statusDot(AppTheme.successGreen, 'Ready'),
      countingDown: (_, _) => _statusDot(AppTheme.warningYellow, 'Counting'),
      active: (_, _) => _statusDot(AppTheme.emergencyRed, 'Active'),
      cancelled: (_) => _statusDot(AppTheme.infoBlue, 'Cancelled'),
      error: (_, _) => _statusDot(AppTheme.emergencyRed, 'Error'),
    );
  }

  Widget _statusDot(Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo(WidgetRef ref) {
    final contactsCountAsync = ref.watch(contactsCountProvider);
    final countdownDuration = ref.watch(settingsProvider);

    final contactsCount = contactsCountAsync.when(
      data: (count) => count,
      loading: () => 0,
      error: (_, _) => 0,
    );
    final contactsLabel = contactsCount == 1
        ? '1 Contact'
        : '$contactsCount Contacts';
    final hasContacts = contactsCount > 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                icon: Icons.people_outline,
                label: contactsLabel,
                color: hasContacts ? null : AppTheme.warningYellow,
              ),
              const SizedBox(width: 12),
              _GpsStatusChip(locationService: ref.read(locationServiceProvider)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '$countdownDuration second countdown before alert is sent',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textBrandMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    final iconColor = color ?? AppTheme.textBrandSecondary;
    final textColor = color ?? AppTheme.textBrandSecondary;
    final borderColor = color?.withValues(alpha: 0.4) ?? AppTheme.dividerBrand;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBrand,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stateful widget that checks GPS status asynchronously and rebuilds.
class _GpsStatusChip extends StatefulWidget {
  final LocationService locationService;

  const _GpsStatusChip({required this.locationService});

  @override
  State<_GpsStatusChip> createState() => _GpsStatusChipState();
}

class _GpsStatusChipState extends State<_GpsStatusChip>
    with WidgetsBindingObserver {
  bool _serviceEnabled = false;
  bool _hasPermission = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check when app resumes (user may have toggled GPS in settings)
    if (state == AppLifecycleState.resumed) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    final serviceEnabled = await widget.locationService.isServiceEnabled();
    final hasPermission = await widget.locationService.hasPermission();
    if (mounted) {
      setState(() {
        _serviceEnabled = serviceEnabled;
        _hasPermission = hasPermission;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return _chip(Icons.location_searching, 'GPS...', null);
    }

    if (!_serviceEnabled) {
      return _chip(Icons.location_off_outlined, 'GPS Off', AppTheme.emergencyRed);
    }
    if (!_hasPermission) {
      return _chip(Icons.location_disabled_outlined, 'No Permission',
          AppTheme.warningYellow);
    }
    return _chip(Icons.location_on_outlined, 'GPS Active', AppTheme.successGreen);
  }

  Widget _chip(IconData icon, String label, Color? color) {
    final iconColor = color ?? AppTheme.textBrandSecondary;
    final textColor = color ?? AppTheme.textBrandSecondary;
    final borderColor = color?.withValues(alpha: 0.4) ?? AppTheme.dividerBrand;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceBrand,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    );
  }
}
