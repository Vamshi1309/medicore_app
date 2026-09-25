import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistDashboard extends ConsumerStatefulWidget {
  const ReceptionistDashboard({super.key});

  @override
  ConsumerState<ReceptionistDashboard> createState() =>
      _ReceptionistDashboardState();
}

class _ReceptionistDashboardState extends ConsumerState<ReceptionistDashboard> {
  bool isTapped = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopHeader(context, 2, 3),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _buildHeading(),
              SizedBox(height: 15),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Text(
                            "VD",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vamshi Dasari",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Uday Kummar . Dermatology",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.clock,
                                  size: 12,
                                  color: Colors.grey.shade600,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "10:30 AM",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Spacer(flex: 3),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: StatusBadge(
                            status: AppointmentStatus.confirmed.label,
                            backgroundColor:
                                AppointmentStatus.confirmed.backgroundColor,
                            textColor: AppointmentStatus.confirmed.textColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (!isTapped) ...[
                      Divider(height: 25),
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton.primary(
                                text: "Confirm",
                                fontSize: 16,
                                prefixIcon: LucideIcons.check,
                                isTextBold: true,
                                onPressed: () {
                                  setState(() {
                                    isTapped = true;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: PrimaryButton.primary(
                                text: "Cancel",
                                fontSize: 16,
                                isTextBold: false,
                                color: Colors.red.shade100,
                                prefixIcon: LucideIcons.x,
                                foregroundColor: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    isTapped = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Schedule",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(
          "Sep 24, 2026",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    int appointmentCount,
    int prescriptionCount,
  ) {
    final user = ref.watch(authProvider).user;

    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 32,
          left: AppSizes.lg,
          right: AppSizes.lg,
          bottom: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good Morning,',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: AppSizes.xs),
                      Text(
                        user?.name ?? "Doctor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //specialtyBadge(),
                    ],
                  ),
                ),
                Badge(
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: Colors.white.withAlpha(55),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        // Open notifications
                      },
                      icon: Icon(
                        LucideIcons.bell500Dir,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _statCardStyled(appointmentCount.toString(), "Total"),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(
                  child: _statCardStyled(
                    prescriptionCount.toString(),
                    'Pending',
                  ),
                ),
                const SizedBox(width: AppSizes.md),
                Expanded(child: _statCardStyled("4", 'Confirmed')),
              ],
            ),
            SizedBox(height: 15),
            PrimaryButton.primary(
              text: "Book new Appointment",
              prefixIcon: LucideIcons.calendarPlus,
              foregroundColor: Colors.blue,
              color: Colors.white,

              onPressed: () {
                //will implement
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCardStyled(String value, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
