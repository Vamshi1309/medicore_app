import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/widgets/profile/info_section.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistProfileScreen extends StatefulWidget {
  const ReceptionistProfileScreen({super.key});

  @override
  State<ReceptionistProfileScreen> createState() =>
      _ReceptionistProfileScreenState();
}

class _ReceptionistProfileScreenState extends State<ReceptionistProfileScreen> {
  bool isEditingShift = false;
  String selectedShift = 'Night Shift';

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

  @override
  Widget build(BuildContext context) {
    final currentShift = shiftOptions.firstWhere(
      (shift) => shift.title == selectedShift,
      orElse: () => shiftOptions[2],
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              ProfileHeader(
                name: 'Maya Thornton',
                role: 'Receptionist',
                subtitle: 'maya.thorton@clinic.com',
                showRoleBadge: true,
                avatarLetter: 'MT',
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
                      rows: const [
                        InfoRowData(label: 'Full Name', value: 'Maya Thornton'),
                        InfoRowData(label: 'Phone', value: '+1 90000 12345'),
                        InfoRowData(
                          label: 'Email',
                          value: 'maya.thorton@clinic.com',
                        ),
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
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    isEditingShift = !isEditingShift;
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                icon: const Icon(
                                  LucideIcons.pencil,
                                  size: 16,
                                  color: Color(0xFF2D6BFF),
                                ),
                                label: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D6BFF),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20, thickness: 1),
                          const SizedBox(height: 4),
                          if (isEditingShift) ...[
                            ...shiftOptions.map((shift) {
                              final isChosen = shift.title == selectedShift;
                              final selectedColor = isChosen
                                  ? shift.iconColor
                                  : const Color(0xFF9AA1AC);
                              final selectedTextColor = isChosen
                                  ? shift.iconColor
                                  : const Color(0xFF4B5563);
                              final selectedTimeColor = isChosen
                                  ? shift.iconColor
                                  : const Color(0xFF6B7280);
                              final selectedBg = isChosen
                                  ? shift.selectedBackground
                                  : const Color(0xFFF3F4F6);

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedShift = shift.title;
                                      isEditingShift = false;
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(10),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selectedBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          shift.icon,
                                          size: 18,
                                          color: selectedColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                shift.title,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: selectedTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                shift.time,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: selectedTimeColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isChosen)
                                          Icon(
                                            LucideIcons.check,
                                            size: 18,
                                            color: shift.iconColor,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ] else ...[
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
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
                                            color: currentShift.iconColor,
                                            fontWeight: FontWeight.w600,
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton.primary(
                      text: 'Edit Profile',
                      prefixIcon: LucideIcons.pencilLine,
                      onPressed: () {},
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