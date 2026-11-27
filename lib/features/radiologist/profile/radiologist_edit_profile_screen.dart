import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/radiologist/common/radiologist_format.dart';
import 'package:frontend/features/radiologist/data/models/update_radiologist_profile_request.dart';
import 'package:frontend/features/radiologist/data/providers/radiologist_profile_provider.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:go_router/go_router.dart';

class RadiologistEditProfileScreen extends ConsumerStatefulWidget {
  const RadiologistEditProfileScreen({super.key});

  @override
  ConsumerState<RadiologistEditProfileScreen> createState() =>
      _RadiologistEditProfileScreenState();
}

class _RadiologistEditProfileScreenState
    extends ConsumerState<RadiologistEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _labController = TextEditingController();
  final _certController = TextEditingController();

  bool _isSaving = false;
  bool _filled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _labController.dispose();
    _certController.dispose();
    super.dispose();
  }

  void _fillFromProfile() {
    if (_filled) return;

    final profile = ref.read(radiologistProfileProvider).asData?.value;

    if (profile == null) return;

    final user = ref.read(authProvider).user;

    _nameController.text = (profile.name ?? user?.name ?? '').trim();
    _phoneController.text = profile.phoneNumber ?? '';
    _labController.text = profile.labSection ?? '';
    _certController.text = profile.certification ?? '';

    _filled = true;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final message = await ref
          .read(radiologistProfileProvider.notifier)
          .updateProfile(
            UpdateRadiologistProfileRequest(
              name: _nameController.text.trim(),
              phoneNumber: _phoneController.text.trim(),
              labSection: _labController.text.trim(),
              certification: _certController.text.trim(),
            ),
          );

      if (!mounted) return;

      AppSnackBar.success(context, message);
      context.pop();
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      AppSnackBar.error(
        context,
        error is ApiException ? error.message : 'Something went wrong',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final profileAsync = ref.watch(radiologistProfileProvider);

    _fillFromProfile();

    final name = _nameController.text.trim().isEmpty
        ? radiologistDisplay(user?.name)
        : _nameController.text.trim();

    final role = radiologistRoleLabel(user?.role.name);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: profileAsync.when(
          skipLoadingOnReload: true,
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    error is ApiException
                        ? error.message
                        : 'Could not load profile',
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(radiologistProfileProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (_) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ProfileHeader(
                      name: name,
                      role: role,
                      isEditable: true,
                      avatarLetter: radiologistInitials(name),
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

                            // Name - Editable
                            _EditField(
                              label: 'Full Name',
                              controller: _nameController,
                            ),

                            const SizedBox(height: 12),

                            // Staff ID - Not Editable
                            _EditField(
                              label: 'Staff ID',
                              initialValue: radiologistDisplay(user?.staffId),
                              enabled: false,
                              suffixIcon: Icons.lock_outline_rounded,
                            ),

                            const SizedBox(height: 12),

                            // Phone Number - Editable
                            _EditField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Required';
                                }

                                if (value.length != 10) {
                                  return 'Enter a valid 10-digit phone number';
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 12),

                            // Lab Section - Editable
                            _EditField(
                              label: 'Lab Section',
                              controller: _labController,
                            ),

                            const SizedBox(height: 12),

                            // Certification - Editable
                            _EditField(
                              label: 'Certification',
                              controller: _certController,
                              maxLines: 3,
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
                            isLoading: _isSaving,
                            onPressed: _submit,
                          ),

                          const SizedBox(height: 12),

                          PrimaryButton.outlinedFilled(
                            text: 'Cancel',
                            onPressed: _isSaving ? null : () => context.pop(),
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
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool enabled;
  final IconData? suffixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const _EditField({
    required this.label,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.suffixIcon,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
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
          initialValue: controller == null ? initialValue : null,
          enabled: enabled,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? const Color(0xFFF6F8FB)
                : const Color(0xFFE3E8F5),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, size: 18, color: const Color(0xFF6B7280)),
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
              borderSide: const BorderSide(
                color: Color(0xFF2A6DEB),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
          validator: enabled
              ? validator ??
                    (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Required';
                      }

                      return null;
                    }
              : null,
        ),
      ],
    );
  }
}
