import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/providers/all_appointments_provider.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/receptionist/widgets/receptionist_app_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistDashboard extends ConsumerStatefulWidget {
  const ReceptionistDashboard({super.key});

  @override
  ConsumerState<ReceptionistDashboard> createState() =>
      _ReceptionistDashboardState();
}

class _ReceptionistDashboardState extends ConsumerState<ReceptionistDashboard> {
  @override
  Widget build(BuildContext context) {
    final appointmentsState = ref.watch(allAppointmentsProvider);

    return Column(
      children: [
        _buildTopHeader(context, appointmentsState),
        SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _buildHeading(),
                const SizedBox(height: 15),
                Expanded(
                  child: appointmentsState.when(
                    data: (data) {
                      final pendingAppointments = data
                          .where(
                            (appointment) =>
                                appointment.status == AppointmentStatus.pending,
                          )
                          .take(5)
                          .toList();

                      if (pendingAppointments.isEmpty) {
                        return const Center(
                          child: Text('No pending appointments'),
                        );
                      }

                      return ListView.builder(
                        itemCount: pendingAppointments.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ReceptionistAppCard(
                              appointment: pendingAppointments[index],
                            ),
                          );
                        },
                      );
                    },
                    error: (err, stackTrace) {
                      return Center(
                        child: ErrorState(
                          title: 'Error',
                          subtitle: err.toString(),
                        ),
                      );
                    },
                    loading: () {
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
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
          DateFormat('MMM d, yyyy').format(DateTime.now()),
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
    AsyncValue<List<AppointmentResponse>> appointments,
  ) {
    final user = ref.watch(authProvider).user;

    return appointments.when(
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
      error: (error, stackTrace) => const SizedBox(
        height: 100,
        child: Center(
          child: Text(
            'Unable to load appointment statistics',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      data: (data) {
        final appointmentCount = data.length;
        final pendingCount = data
            .where((a) => a.status == AppointmentStatus.pending)
            .length;
        final confirmedCount = data
            .where((a) => a.status == AppointmentStatus.confirmed)
            .length;

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
                            user?.name ?? 'Receptionist',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                          icon: const Icon(
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
                      child: _statCardStyled(
                        appointmentCount.toString(),
                        'Total',
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _statCardStyled(
                        pendingCount.toString(),
                        'Pending',
                      ),
                    ),
                    const SizedBox(width: AppSizes.md),
                    Expanded(
                      child: _statCardStyled(
                        confirmedCount.toString(),
                        'Confirmed',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                PrimaryButton.primary(
                  text: 'Book new Appointment',
                  prefixIcon: LucideIcons.calendarPlus,
                  foregroundColor: Colors.blue,
                  color: Colors.white,
                  onPressed: () {
                    context.go(AppRoutes.receptionistBook);
                  },
                ),
              ],
            ),
          ),
        );
      },
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
