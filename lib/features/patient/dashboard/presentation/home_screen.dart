import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
// bottom nav moved to PatientShell
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/prescription_provider.dart';
import 'package:frontend/features/patient/dashboard/widgets/custom_app_bar.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/features/patient/dashboard/widgets/dashboard_outlined_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(authProvider, (prev, next) {
      if (next.error != null) {
        AppSnackBar.error(context, next.error!);
      }

      if (next.message != null) {
        AppSnackBar.success(context, next.message!);
      }
    });

    ref.listenManual(patientAppointmentsProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : 'Something went wrong';

          AppSnackBar.error(context, message);
        },
      );
    });

    ref.listenManual(prescriptionProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : 'Something went wrong';

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(patientAppointmentsProvider);
    final prescriptionsAsync = ref.watch(prescriptionProvider);

    final upcomingAppointments = appointmentsAsync.whenData((list) {
      final upcoming = list
          .where(
            (a) =>
                a.status == AppointmentStatus.pending ||
                a.status == AppointmentStatus.confirmed,
          )
          .toList();

      upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      return upcoming;
    });

    final prescriptionsList = prescriptionsAsync.whenData((list) {
      return list;
    });

    final nextAppointment = upcomingAppointments.when(
      data: (list) => list.isNotEmpty ? list.first : null,
      loading: () => null,
      error: (_, _) => null,
    );

    return Scaffold(
      appBar: CustomAppBar(
        userRole: ref.watch(authProvider).user?.role.name ?? "No role",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              displayDashboardCard(nextAppointment),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardOutlinedCard(
                    color: Colors.blue.shade100,
                    icon: LucideIcons.calendarCheck600Dir,
                    count: upcomingAppointments.when(
                      data: (list) => Text(
                        list.length.toString(),
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 30),
                      ),
                      loading: () => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      error: (_, _) => Text(
                        '0',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 30),
                      ),
                    ),
                    text: "Upcoming",
                  ),
                  DashboardOutlinedCard(
                    color: Colors.lightBlueAccent.shade200,
                    icon: LucideIcons.fileText600Dir,
                    count: prescriptionsList.when(
                      data: (list) => Text(
                        list.length.toString(),
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 30),
                      ),
                      loading: () => const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      error: (_, _) => Text(
                        '0',
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(fontSize: 30),
                      ),
                    ),
                    text: "Prescriptions",
                  ),
                  DashboardOutlinedCard(
                    color: Colors.green.shade100,
                    icon: LucideIcons.clipboard600,
                    count: Text(
                      "7",
                      style: Theme.of(
                        context,
                      ).textTheme.displayMedium?.copyWith(fontSize: 30),
                    ),
                    text: "Reports",
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Actions", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 15),
              PrimaryButton(
                text: "Book Appointment",
                icon: LucideIcons.calendarPlus300Dir,
                color: Colors.blue.shade700,
                onPressed: () {},
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Upcoming Appointments",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See all",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blue.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              upcomingAppointments.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (_, _) => const SizedBox.shrink(),

                data: (appointments) {
                  if (appointments.isEmpty) {
                    return const EmptyState(
                      icon: LucideIcons.calendarX,
                      title: 'No upcoming appointments',
                      subtitle: 'You have no upcoming appointments.',
                    );
                  }

                  return ListView.builder(
                    itemCount: min(appointments.length, 5),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      final appointment = appointments[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),

                        child: Row(
                          children: [
                            // Doctor avatar
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue.shade50,
                              child: Text(
                                appointment.doctorName
                                    .replaceFirst('Dr. ', '')
                                    .substring(0, 1),
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Doctor information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.doctorName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    '${appointment.doctorSpecialization ?? 'General'} · '
                                    '${appointment.scheduledAt}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Status
                            StatusBadge(
                              status: appointment.status.label,
                              fontSize: 11,
                              icon: appointment.status.icon,
                              backgroundColor:
                                  appointment.status.backgroundColor,
                              textColor: appointment.status.textColor,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget displayDashboardCard(AppointmentResponse? nextAppointment) {
    if (nextAppointment == null) {
      return _buildNoNextAppointmentCard();
    }

    return DashboardCard(
      role: ref.read(authProvider).user?.role.name ?? "No user",
      color: Colors.blue.shade700,
      buttonText: 'View',
      textFontColor: Colors.blue.shade700,
      textBgColor: Colors.white,
      onPressed: () {},
      children: [
        Text(
          "Next Appointment",
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: Colors.white70),
        ),

        const SizedBox(height: 5),

        Text(
          nextAppointment.doctorName,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),

        const SizedBox(height: 5),

        Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 16,
            ),

            const SizedBox(width: 5),

            Text(
              nextAppointment.scheduledAt.toIso8601String().split('T')[0],
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.white70),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                nextAppointment.doctorSpecialization ?? "General",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNoNextAppointmentCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              LucideIcons.calendarX,
              size: 28,
              color: Colors.blue.shade700,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No next appointment',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Book an appointment to get started',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade200),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          IconButton(
            onPressed: () {
              // Navigate to booking screen
            },
            style: IconButton.styleFrom(
              foregroundColor: Colors.blue.shade700,
              backgroundColor: Colors.white,
            ),
            icon: const Icon(LucideIcons.arrowRight, size: 18),
          ),
        ],
      ),
    );
  }
}
