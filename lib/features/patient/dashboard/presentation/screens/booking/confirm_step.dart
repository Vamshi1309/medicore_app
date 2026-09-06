import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_booking_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/get_all_doctors_provider.dart';
import 'package:frontend/features/patient/dashboard/widgets/doctor_card.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ConfirmBookingUiState { review, loading, success, error }

class ConfirmStep extends ConsumerStatefulWidget {
  const ConfirmStep({super.key});

  @override
  ConsumerState<ConfirmStep> createState() => _ConfirmStepState();
}

class _ConfirmStepState extends ConsumerState<ConfirmStep> {
  ConfirmBookingUiState uiState = ConfirmBookingUiState.review;
  AppointmentResponse? appointment;
  String? errorMessage;

  @override
  initState() {
    super.initState();
    ref.listenManual(patientAppointmentsProvider, (prev, next) {
      if (next.error != null) {
        AppSnackBar.error(context, next.error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorsAsync = ref.watch(getAllDoctorsProvider);
    final bookingState = ref.watch(appointmentBookingProvider);
    final appointmentAsync = ref.read(patientAppointmentsProvider.notifier);

    if (uiState == ConfirmBookingUiState.success) {
      return _SuccessView(appointment: appointment!);
    }

    if (uiState == ConfirmBookingUiState.error) {
      return ErrorState(
        title: "Failed to book appointment",
        subtitle: errorMessage ?? "Failed to book appointment",
        onRetry: () {
          setState(() {
            uiState = ConfirmBookingUiState.review;
          });
        },
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Confirm Booking",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Review your appointment details",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          doctorsAsync.when(
            data: (doctors) {
              if (doctors.isEmpty) {
                return EmptyState(
                  icon: LucideIcons.alertTriangle,
                  title: 'Error',
                  subtitle: 'No doctors available',
                );
              }

              final selectedDoctor = doctors.firstWhere(
                (d) => d.userId == bookingState.doctorId,
              );
              return DoctorCard(
                name: selectedDoctor.name,
                experienceInYears: selectedDoctor.experienceInYears.toString(),
                speciality: selectedDoctor.specialization,
                color: Colors.cyan.shade300,
                isSelected: false,
              );
            },
            error: (_, _) {
              return EmptyState(
                icon: LucideIcons.alertTriangle,
                title: 'Error',
                subtitle: 'Failed to load doctors',
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: [
                _buildCardRow(
                  icon: LucideIcons.calendar,
                  label: "Date",
                  value: DateFormat(
                    'EEE, MMMM d, yyyy',
                  ).format(bookingState.selectedDate!),
                ),
                Divider(height: 20, color: Colors.grey.shade300),
                _buildCardRow(
                  icon: LucideIcons.clock,
                  label: "Time",
                  value: bookingState.selectedTime!,
                ),

                if (bookingState.notes != null &&
                    bookingState.notes!.isNotEmpty) ...[
                  Divider(height: 20, color: Colors.grey.shade300),
                  _buildCardRow(
                    icon: LucideIcons.clipboard,
                    label: "Notes",
                    value: bookingState.notes!,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.circleCheckBig,
                  color: Colors.blue.shade800,
                  size: 18,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "You will receive a confirmation once the doctor approves your appointment.",
                    style: TextStyle(color: Colors.blue.shade800, fontSize: 14),
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),

          Spacer(),
          PrimaryButton(
            text: "Confirm Appointment",
            isTextBold: true,
            suffixIcon: LucideIcons.chevronRight,
            onPressed: () async {
              setState(() {
                uiState = ConfirmBookingUiState.loading;
              });

              try {
                final response = await appointmentAsync.createAppointment(
                  bookingState,
                );

                setState(() {
                  appointment = response;
                  uiState = ConfirmBookingUiState.success;
                });
              } catch (e) {
                setState(() {
                  errorMessage = e.toString();
                  uiState = ConfirmBookingUiState.error;
                });
              }
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCardRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade800, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              Text(
                value.trim(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 14),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  final AppointmentResponse appointment;

  const _SuccessView({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 40),

          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.green.shade100,
            child: Icon(
              LucideIcons.circleCheckBig,
              size: 48,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Appointment Booked!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(
            "Your appointment has been sent for confirmation.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600,fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 24),

          AppCard(
            child: Column(
              children: [
                _row("Doctor", appointment.doctorName),
                _row(
                  "Date",
                  DateFormat("MMMM d, yyyy").format(appointment.scheduledAt),
                ),
                _row(
                  "Time",
                  DateFormat("hh:mm a").format(appointment.scheduledAt),
                ),
                _row(
                  "Status",
                  appointmentStatusToString(appointment.status),
                  valueColor: Colors.orange,
                ),
              ],
            ),
          ),

          const Spacer(),

          PrimaryButton(
            text: "Back to Home",
            onPressed: () {
              context.go(AppRoutes.patientHome);
            },
          ),
        ],
      ),
    );
  }

  static Widget _row(String title, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ],
      ),
    );
  }
}
