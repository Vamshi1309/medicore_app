import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditReceptionistProfileScreen extends ConsumerStatefulWidget {
  const EditReceptionistProfileScreen({super.key});

  @override
  ConsumerState<EditReceptionistProfileScreen> createState() =>
      _EditReceptionistProfileScreenState();
}

class _EditReceptionistProfileScreenState
    extends ConsumerState<EditReceptionistProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final user = ref.read(authProvider).user;
    _fullNameController.text = user?.name ?? 'Maya Thornton';
    _phoneController.text = user?.phoneNumber ?? '+1 90000 12345';
    _emailController.text = 'maya.thorton@clinic.com';
    _roleController.text = user?.role.name ?? 'Receptionist';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Stack(
                children: [
                  ProfileHeader(
                    name: user?.name ?? 'Maya Thornton',
                    role: user?.role.name ?? 'Receptionist',
                    isEditable: true,
                    avatarLetter: 'MT',
                  ),
                  Positioned(
                    top: 18,
                    left: 16,
                    child: IconButton(
                      onPressed: () => ref.read(goRouterProvider).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
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
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.userRound,
                                size: 18,
                                color: Color(0xFF1A1A1A),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _Field(
                            label: 'Full Name',
                            controller: _fullNameController,
                          ),
                          const SizedBox(height: 10),
                          _Field(
                            label: 'Phone',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 10),
                          _Field(
                            label: 'Email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 10),
                          _Field(
                            label: 'Role',
                            controller: _roleController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton.primary(
                      text: 'Save Changes',
                      onPressed: () => ref.read(goRouterProvider).pop(),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton.primary(
                      text: 'Cancel',
                      foregroundColor: Colors.black,
                      color: Colors.white,
                      onPressed: () => ref.read(goRouterProvider).pop(),
                    ),
                  ],
                ),
              ),
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
            color: Color(0xFF666E7A),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF1F2937),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF4F6F9),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE6EAF0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF2D6BFF),
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFE6EAF0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
