import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:go_router/go_router.dart';

/// Profile data passed to the edit screen and returned from it.
/// (Mock model. Replace with your real user entity later.)
class RadiologistProfileData {
  final String name;
  final String staffId;
  final String phone;
  final String labSection;
  final String certification;

  const RadiologistProfileData({
    required this.name,
    required this.staffId,
    required this.phone,
    required this.labSection,
    required this.certification,
  });

  RadiologistProfileData copyWith({
    String? name,
    String? phone,
    String? labSection,
    String? certification,
  }) {
    return RadiologistProfileData(
      name: name ?? this.name,
      staffId: staffId,
      phone: phone ?? this.phone,
      labSection: labSection ?? this.labSection,
      certification: certification ?? this.certification,
    );
  }

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

/// Edit profile screen. UI only: validates the fields, fakes a short save
/// delay, then returns the updated data to the profile screen.
class RadiologistEditProfileScreen extends StatefulWidget {
  final RadiologistProfileData? initial;

  const RadiologistEditProfileScreen({super.key, this.initial});

  @override
  State<RadiologistEditProfileScreen> createState() =>
      _RadiologistEditProfileScreenState();
}

class _RadiologistEditProfileScreenState
    extends State<RadiologistEditProfileScreen> {
  static const _bg = Color(0xFFEAEFFA);
  static const _textDark = Color(0xFF1B1E2B);
  static const _textGrey = Color(0xFF6B7280);
  static const _border = Color(0xFFD7DFF2);
  static const _error = Color(0xFFC62828);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _labController;
  late final TextEditingController _certController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _initial.name);
    _phoneController = TextEditingController(text: _initial.phone);
    _labController = TextEditingController(text: _initial.labSection);
    _certController = TextEditingController(text: _initial.certification);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _labController.dispose();
    _certController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- actions

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await Future<void>.delayed(const Duration(milliseconds: 1000)); // fake request
    if (!mounted) return;
    setState(() => _isSaving = false);

    context.pop(
      _initial.copyWith(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        labSection: _labController.text.trim(),
        certification: _certController.text.trim(),
      ),
    );
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ProfileHeader(
                    name: _initial.name,
                    role: 'Radiologist',
                    isEditable: true,
                    avatarLetter: _initial.initials,
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
                          _EditField(label: 'Full Name', controller: _nameController),
                          const SizedBox(height: 12),
                          _EditField(
                            label: 'Staff ID',
                            initialValue: _initial.staffId,
                            enabled: false,
                            suffixIcon: Icons.lock_outline_rounded,
                          ),
                          const SizedBox(height: 12),
                          _EditField(
                            label: 'Phone Number',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _EditField(label: 'Lab Section', controller: _labController),
                          const SizedBox(height: 12),
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
    );
  }

  // ---------------------------------------------------------------- helpers

  RadiologistProfileData get _initial => widget.initial ?? const RadiologistProfileData(
        name: 'Elena Rodriguez',
        staffId: 'RAD-0001',
        phone: '9300000001',
        labSection: 'Radiology Lab, Imaging Wing',
        certification: 'Board Certified in Diagnostic Radiology',
      );
}

// =============================================================== components

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool enabled;
  final IconData? suffixIcon;
  final int maxLines;
  final List<TextInputFormatter>? inputFormatters;

  const _EditField({
    required this.label,
    this.controller,
    this.initialValue,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.suffixIcon,
    this.maxLines = 1,
    this.inputFormatters,
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
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? const Color(0xFFF6F8FB) : const Color(0xFFE3E8F5),
            suffixIcon: suffixIcon == null
                ? null
                : Icon(suffixIcon, size: 18, color: const Color(0xFF6B7280)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          validator: enabled
              ? (value) {
                  if (value == null || value.trim().isEmpty) return 'Required';
                  if (keyboardType == TextInputType.phone && value.trim().length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}