import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/user_profile/data/user_profile_repository.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';
import 'package:my_panic/features/auth/data/auth_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Medical Info Controllers (Simplified for onboarding)
  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _medicationsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) throw Exception('User not logged in');

      final medicalProfile = MedicalProfile(
        bloodType: _bloodTypeController.text.trim(),
        allergies: _allergiesController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        conditions: _conditionsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        medications: _medicationsController.text
            .trim()
            .split(',')
            .map((e) => e.trim())
            .toList(),
        insuranceInfo: '', // Can be added in settings later
        emergencyNotes: '',
      );

      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        medicalProfile: medicalProfile,
        isProfileComplete: true,
      );

      debugPrint('Creating UserProfile:');
      debugPrint('UID: ${user.uid}');
      debugPrint('Email: ${user.email}');
      debugPrint(
        'Name: ${_firstNameController.text} ${_lastNameController.text}',
      );
      debugPrint('Phone: ${_phoneController.text}');
      debugPrint('Medical: $medicalProfile');

      await ref.read(userProfileRepositoryProvider).createUserProfile(profile);

      // Router should pick up the change in profile stream or we force refresh
      if (mounted) {
        // Force router refresh if needed, but the router should act on the stream
      }
    } catch (e, st) {
      debugPrint('Error saving profile: $e');
      debugPrint('Stack trace: $st');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Setup Your Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/MyPanic-logo-heart.png',
                  height: 80,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Help us help you in an emergency by providing your basic details.',
                style: TextStyle(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Personal Info'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),

              const SizedBox(height: 32),
              _buildSectionTitle('Medical Snapshot (Optional)'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(
                  labelText: 'Blood Type (e.g. O+)',
                  prefixIcon: Icon(Icons.bloodtype_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                  labelText: 'Allergies (comma separated)',
                  prefixIcon: Icon(Icons.warning_amber_rounded),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _conditionsController,
                decoration: const InputDecoration(
                  labelText: 'Medical Conditions',
                  prefixIcon: Icon(Icons.medical_services_outlined),
                ),
              ),

              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: AppTheme.textPrimary,
                      )
                    : const Text(
                        'Complete Setup',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryRed,
      ),
    );
  }
}
