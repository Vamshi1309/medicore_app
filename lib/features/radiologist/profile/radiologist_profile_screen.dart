import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/radiologist/common/radiologist_format.dart';
import 'package:frontend/features/radiologist/data/models/radiologist_profile_response.dart';
import 'package:frontend/features/radiologist/data/providers/radiologist_profile_provider.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:go_router/go_router.dart';

import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';

class RadiologistProfileScreen extends ConsumerWidget {
  const RadiologistProfileScreen({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(radiologistProfileProvider);
    final user = ref.watch(authProvider).user;
    final name = radiologistDisplay(user?.name);
    final role = radiologistRoleLabel(user?.role.name);

    return profileAsync.when(
      skipLoadingOnReload: true,
      loading: () => _StatusScaffold(
        name: name,
        role: role,
        child: const CircularProgressIndicator(),
      ),
      error: (error, _) => _StatusScaffold(
        name: name,
        role: role,
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
      data: (profile) => _ProfileBody(
        name: name,
        role: role,
        profile: profile,
        staffId: radiologistDisplay(user?.staffId),
        onEdit: () => context.push(AppRoutes.radiologistEditProfile),
        onLogout: () => _confirmLogout(context, ref),
      ),
    );
  }
}

class _StatusScaffold extends StatelessWidget {
  final String name;
  final String role;
  final Widget child;

  const _StatusScaffold({
    required this.name,
    required this.role,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F6),
      body: SafeArea(
        child: Column(
          children: [
            ProfileHeader(
              name: name,
              role: role,
              isEditable: false,
              avatarLetter: radiologistInitials(name),
            ),
            Expanded(child: Center(child: child)),
          ],
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final String name;
  final String role;
  final RadiologistProfileResponse profile;
  final String staffId;
  final VoidCallback onEdit;
  final VoidCallback onLogout;

  const _ProfileBody({
    required this.name,
    required this.role,
    required this.profile,
    required this.staffId,
    required this.onEdit,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    const blueDark = Color(0xFF0B5ED7);

    return Scaffold(
      backgroundColor: const Color(0xFFEAF2F6),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfileHeader(
                      name: name,
                      role: role,
                      isEditable: false,
                      subtitle: radiologistDisplay(profile.labSection),
                      avatarLetter: radiologistInitials(name),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Professional details',
                              style: TextStyle(
                                color: Color(0xFF1D2A3A),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF6F8FB),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: _DetailRow(
                                icon: Icons.description_outlined,
                                label: 'Certification',
                                value: radiologistDisplay(profile.certification),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.badge_outlined,
                              iconColor: blueDark,
                              label: 'Staff ID',
                              value: staffId,
                            ),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            _InfoRow(
                              icon: Icons.phone_outlined,
                              iconColor: blueDark,
                              label: 'Phone number',
                              value: radiologistDisplay(profile.phoneNumber),
                            ),
                            const Divider(height: 1, color: Color(0xFFE2E8F0)),
                            _InfoRow(
                              icon: Icons.biotech_outlined,
                              iconColor: blueDark,
                              label: 'Lab section',
                              value: radiologistDisplay(profile.labSection),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: PrimaryButton.primary(
                        text: 'Edit Profile',
                        onPressed: onEdit,
                        prefixIcon: Icons.edit_rounded,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: PrimaryButton.outlinedFilled(
                        text: 'Log out',
                        onPressed: onLogout,
                        color: const Color(0xFFDD5C5C),
                        foregroundColor: const Color(0xFFDD5C5C),
                        prefixIcon: Icons.logout_rounded,
                        isTextBold: false,
                      ),
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================== components

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1B1E2B),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6D7B9A),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF2D3849),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFBE0DD),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 36,
                color: Color(0xFFC62828),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Log out?',
              style: TextStyle(
                color: Color(0xFF1B1E2B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You will need to sign in again to upload reports.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton.outlined(
                    text: 'Cancel',
                    fontSize: 15,
                    onPressed: () => context.pop(false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton.primary(
                    text: 'Log out',
                    fontSize: 15,
                    color: const Color(0xFFC62828),
                    onPressed: () => context.pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}