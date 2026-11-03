import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/pharmacist/data/models/update_pharmacist_profile_request.dart';
import 'package:frontend/features/pharmacist/data/providers/pharmacist_profile_provider.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';

class EditPharmacistProfileScreen extends ConsumerStatefulWidget {
  const EditPharmacistProfileScreen({super.key});

  @override
  ConsumerState<EditPharmacistProfileScreen> createState() =>
      _EditPharmacistProfileScreenState();
}

class _EditPharmacistProfileScreenState
    extends ConsumerState<EditPharmacistProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = ref.read(authProvider).user;
    _nameController.text = user?.name ?? 'Pharmacist';

    ref.listenManual(pharmacistProfileProvider, (previous, next) {
      next.whenOrNull(
        data: (profile) {
          _emailController.text = profile.email ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _licenseController.text = profile.licenseNumber ?? '';
        },
      );
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final request = UpdatePharmacistProfileRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
    );

    try {
      final message = await ref
          .read(pharmacistProfileProvider.notifier)
          .updatePharmacistProfile(request);

      if (!mounted) return;

      AppSnackBar.success(context, message);
      ref.read(goRouterProvider).pop();
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProfileHeader(
                name: user?.name ?? 'Pharmacist',
                role: user?.role.name ?? 'Pharmacist',
                isEditable: true,
                avatarLetter: 'P',
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A3A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _Field(label: 'Full Name', controller: _nameController),
                      const SizedBox(height: 12),
                      _Field(
                        label: 'Email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      _Field(
                        label: 'License Number',
                        controller: _licenseController,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    PrimaryButton.primary(
                      text: 'Save Changes',
                      onPressed: _saveChanges,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton.outlinedFilled(
                      text: 'Cancel',
                      onPressed: () => ref.read(goRouterProvider).pop(),
                      color: const Color(0xFF2D3849),
                      foregroundColor: const Color(0xFF2D3849),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF667085),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF6F8FB),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF2A6DEB), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
