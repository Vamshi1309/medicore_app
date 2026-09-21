import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/data/models/update_appointment_status_model.dart';
import 'package:frontend/features/appointment/providers/appointment_provider.dart';
import 'package:frontend/features/doctor/appointments/widgets/doctor_appointment_card.dart';
import 'package:frontend/features/doctor/widgets/doctor_header.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:go_router/go_router.dart';

class DoctorAppointmentScreen extends ConsumerStatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  ConsumerState<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState
    extends ConsumerState<DoctorAppointmentScreen> {
  final List<String> tabBarOptions = ['all', 'today', 'upcoming', 'completed'];

  String selectedOption = 'all';

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(appointmentsProvider.notifier).getAppointmentsByDoctorId();
    });

    ref.listenManual(appointmentsProvider, (previous, next) {
      if (!mounted) return;

      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : "Something went wrong";

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  List<AppointmentResponse> _filterAppointments(
    List<AppointmentResponse> appointments,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<AppointmentResponse> filtered;

    switch (selectedOption) {
      case 'today':
        filtered = appointments.where((appointment) {
          final date = appointment.scheduledAt;

          final appointmentDate = DateTime(date.year, date.month, date.day);

          return appointmentDate == today &&
              appointment.status != AppointmentStatus.completed;
        }).toList();
        break;

      case 'upcoming':
        filtered = appointments.where((appointment) {
          final date = appointment.scheduledAt;

          final appointmentDate = DateTime(date.year, date.month, date.day);

          return appointmentDate.isAfter(today);
        }).toList();
        break;

      case 'completed':
        filtered = appointments.where((appointment) {
          return appointment.status == AppointmentStatus.completed;
        }).toList();
        break;

      case 'all':
      default:
        filtered = appointments.toList();
        break;
    }

    // Sort by appointment date/time
    filtered.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    return filtered;
  }

  Widget _buildSegment(String value, String label) {
    final isSelected = selectedOption == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.blue.shade600 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentState = ref.watch(appointmentsProvider);

    final appointments = appointmentState.value ?? [];

    final filteredAppointments = _filterAppointments(appointments);

    final now = DateTime.now();

    final todayCount = appointments.where((appointment) {
      final date = appointment.scheduledAt;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).length;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DoctorHeader(
              header: "Appointments",
              subHeader: "${appointments.length} Total . $todayCount Today",
              child: Container(
                height: 42,
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildSegment('all', 'All'),
                    _buildSegment('today', 'Today'),
                    _buildSegment('upcoming', 'Upcoming'),
                    _buildSegment('completed', 'Completed'),
                  ],
                ),
              ),
            ),

            if (appointmentState.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (appointmentState.hasError)
              Expanded(
                child: ErrorState(
                  title: "Failed to load appointments",
                  subtitle:
                      "We couldn't load your appointments. Please try again.",
                  onRetry: () {
                    ref
                        .read(appointmentsProvider.notifier)
                        .getAppointmentsByDoctorId();
                  },
                ),
              )
            else
              Expanded(
                child: filteredAppointments.isEmpty
                    ? EmptyState(
                        icon: Icons.calendar_month_outlined,
                        title: "No Appointments",
                        subtitle: "There are no appointments to display.",
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Column(
                          children: filteredAppointments.map((appointment) {
                            return DoctorAppointmentCard(
                              patientName: appointment.patientName,

                              initials: _getInitials(appointment.patientName),

                              appointmentType: appointment.notes.isNotEmpty
                                  ? appointment.notes
                                  : "Appointment",

                              age: 0,

                              date: _formatDate(appointment.scheduledAt),

                              time: _formatTime(appointment.scheduledAt),

                              status: appointment.status,

                              // Is this appointment scheduled for today?
                              isToday:
                                  appointment.scheduledAt.year ==
                                      DateTime.now().year &&
                                  appointment.scheduledAt.month ==
                                      DateTime.now().month &&
                                  appointment.scheduledAt.day ==
                                      DateTime.now().day,

                              // Has the appointment been completed?
                              isCompleted:
                                  appointment.status ==
                                  AppointmentStatus.completed,

                              onConfirm: () {
                                ref
                                    .read(appointmentsProvider.notifier)
                                    .updateAppointmentStatus(
                                      UpdateAppointmentStatusRequest(
                                        status: AppointmentStatus.confirmed,
                                      ),
                                      appointment.appointmentId,
                                    );
                              },

                              onComplete: () {
                                ref
                                    .read(appointmentsProvider.notifier)
                                    .updateAppointmentStatus(
                                      UpdateAppointmentStatusRequest(
                                        status: AppointmentStatus.completed,
                                      ),
                                      appointment.appointmentId,
                                    );
                              },

                              onPrescribe: () {
                                context.push(
                                  AppRoutes.writePrescription,
                                  extra: {
                                    'appointmentId': appointment.appointmentId,
                                    'name': appointment.patientName,
                                    'initials': _getInitials(
                                      appointment.patientName,
                                    ),
                                  },
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.isEmpty || parts.first.isEmpty) {
      return '';
    }

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
