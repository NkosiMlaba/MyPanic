import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_panic/core/theme/app_theme.dart';
import 'package:my_panic/features/auth/data/auth_repository.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/user_profile/data/user_profile_repository.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';
import 'package:my_panic/features/user_profile/presentation/providers/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _conditionsController;
  late TextEditingController _medicationsController;
  late TextEditingController _emergencyNotesController;
  late TextEditingController _insuranceInfoController;

  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _bloodTypeController = TextEditingController();
    _allergiesController = TextEditingController();
    _conditionsController = TextEditingController();
    _medicationsController = TextEditingController();
    _emergencyNotesController = TextEditingController();
    _insuranceInfoController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _conditionsController.dispose();
    _medicationsController.dispose();
    _emergencyNotesController.dispose();
    _insuranceInfoController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserProfile? profile) {
    if (_isInitialized || profile == null) return;

    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName;
    _phoneController.text = profile.phoneNumber;

    final med = profile.medicalProfile;
    _bloodTypeController.text = med.bloodType ?? '';
    _allergiesController.text = med.allergies.join(', ');
    _conditionsController.text = med.conditions.join(', ');
    _medicationsController.text = med.medications.join(', ');
    _emergencyNotesController.text = med.emergencyNotes ?? '';
    _insuranceInfoController.text = med.insuranceInfo ?? '';

    _isInitialized = true;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) throw Exception('User not authenticated');

      final currentProfile = ref.read(userProfileProvider).valueOrNull;

      final medicalProfile = MedicalProfile(
        bloodType: _bloodTypeController.text.trim(),
        allergies: _allergiesController.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        conditions: _conditionsController.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        medications: _medicationsController.text.trim().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
        emergencyNotes: _emergencyNotesController.text.trim(),
        insuranceInfo: _insuranceInfoController.text.trim(),
        doctorName: currentProfile?.medicalProfile.doctorName,
        doctorPhone: currentProfile?.medicalProfile.doctorPhone,
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

      await ref.read(userProfileRepositoryProvider).updateUserProfile(profile);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Profile Updated')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundBrand,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppTheme.successGreen),
            onPressed: _isLoading ? null : _saveProfile,
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) {
          _initializeControllers(profile);
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  ),

                  const SizedBox(height: 24),
                  _buildSectionTitle('Medical Info'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bloodTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Blood Type',
                      prefixIcon: Icon(Icons.bloodtype_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Allergies (comma separated)',
                      prefixIcon: Icon(Icons.warning_amber_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _conditionsController,
                    decoration: const InputDecoration(
                      labelText: 'Conditions (comma separated)',
                      prefixIcon: Icon(Icons.medical_services_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _medicationsController,
                    decoration: const InputDecoration(
                      labelText: 'Medications (comma separated)',
                      prefixIcon: Icon(Icons.medication_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _insuranceInfoController,
                    decoration: const InputDecoration(
                      labelText: 'Insurance Info',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _emergencyNotesController,
                    decoration: const InputDecoration(
                      labelText: 'Emergency Notes',
                      prefixIcon: Icon(Icons.note_outlined),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.brandPink),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: AppTheme.errorRed),
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
        color: AppTheme.brandPink,
      ),
    );
  }
}
