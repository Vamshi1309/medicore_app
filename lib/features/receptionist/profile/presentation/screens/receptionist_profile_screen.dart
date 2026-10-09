import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/receptionist/profile/data/model/shifts_enum.dart';
import 'package:frontend/features/receptionist/profile/presentation/provider/receptionist_profile_provider.dart';
import 'package:frontend/features/widgets/profile/info_section.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistProfileScreen extends ConsumerStatefulWidget {
  const ReceptionistProfileScreen({super.key});

  @override
  ConsumerState<ReceptionistProfileScreen> createState() =>
      _ReceptionistProfileScreenState();
}

class _ReceptionistProfileScreenState
    extends ConsumerState<ReceptionistProfileScreen> {
  final List<_ShiftOption> shiftOptions = const [
    _ShiftOption(
      title: 'Morning Shift',
      time: '07:00 AM - 03:00 PM',
      icon: LucideIcons.sunMedium,
      iconColor: Color(0xFFEEA63A),
      selectedBackground: Color(0xFFFFF2DA),
    ),
    _ShiftOption(
      title: 'Evening Shift',
      time: '03:00 PM - 11:00 PM',
      icon: LucideIcons.sunset,
      iconColor: Color(0xFFF08A46),
      selectedBackground: Color(0xFFFFF0E8),
    ),
    _ShiftOption(
      title: 'Night Shift',
      time: '11:00 PM - 07:00 AM',
      icon: LucideIcons.moonStar,
      iconColor: Color(0xFF2D6BFF),
      selectedBackground: Color(0xFFEAF0FF),
    ),
  ];

  String _shiftTitle(Shifts shift) {
    switch (shift) {
      case Shifts.MORNING:
        return 'Morning Shift';
      case Shifts.AFTERNOON:
        return 'Evening Shift';
      case Shifts.RIGHT:
        return 'Night Shift';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(receptionistProfileProvider);

    if (profileState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (profileState.hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Failed to load receptionist profile'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(receptionistProfileProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final profile = profileState.requireValue;

    final currentShift = shiftOptions.firstWhere(
      (shift) => shift.title == _shiftTitle(profile.shift),
      orElse: () => shiftOptions[0],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ProfileHeader(
                name: authState.user?.name ?? 'Receptionist',
                role: authState.user?.role.name ?? 'Receptionist',
                subtitle: profile.email,
                showRoleBadge: true,
                avatarLetter: (authState.user?.name.isNotEmpty == true)
                    ? authState.user!.name[0].toUpperCase()
                    : 'R',
                isEditable: false,
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    InfoSectionCard(
                      icon: LucideIcons.userRound,
                      title: 'Personal Information',
                      rows: [
                        InfoRowData(
                          label: 'Full Name',
                          value: authState.user?.name ?? 'N/A',
                        ),
                        InfoRowData(label: 'Phone', value: profile.phoneNumber),
                        InfoRowData(label: 'Email', value: profile.email),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
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
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.clock3,
                                size: 18,
                                color: Color(0xFF1A1A1A),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Shift Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: currentShift.selectedBackground,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  currentShift.icon,
                                  size: 18,
                                  color: currentShift.iconColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentShift.title,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: currentShift.iconColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        currentShift.time,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: currentShift.iconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  LucideIcons.check,
                                  size: 18,
                                  color: currentShift.iconColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton.primary(
                      text: 'Edit Profile',
                      prefixIcon: LucideIcons.pencilLine,
                      onPressed: () {
                        ref
                            .read(goRouterProvider)
                            .push(AppRoutes.receptionistEditProfile);
                      },
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton.outlinedFilled(
                      text: 'Logout',
                      prefixIcon: LucideIcons.logOut,
                      color: Colors.red,
                      onPressed: () {},
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

class _ShiftOption {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color selectedBackground;

  const _ShiftOption({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.selectedBackground,
  });
}
