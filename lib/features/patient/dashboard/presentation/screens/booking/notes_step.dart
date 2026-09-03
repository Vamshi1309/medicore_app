import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_booking_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/get_all_doctors_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotesStep extends ConsumerStatefulWidget {
  const NotesStep({super.key});

  @override
  ConsumerState<NotesStep> createState() => _NotesStepState();
}

class _NotesStepState extends ConsumerState<NotesStep> {
  final TextEditingController _notesController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(appointmentBookingProvider);
    final doctorsAsync = ref.watch(getAllDoctorsProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Notes",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Optional - share any symptoms or details",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      LucideIcons.clipboardList500,
                      color: Colors.blue,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Your appointment summary",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildSummaryRow(
                  label: "Doctor",
                  value: doctorsAsync.when(
                    data: (d) {
                      final doctor = d
                          .where((doc) => doc.userId == bookingState.doctorId)
                          .firstOrNull;
                      return doctor?.name ?? "Not selected";
                    },
                    error: (_, _) => "Error loading doctor",
                    loading: () => "Not Selected",
                  ),
                ),
                _buildSummaryRow(
                  label: "Date",
                  value: DateFormat(
                    'MMMM d, yyyy',
                  ).format(bookingState.selectedDate!),
                ),
                _buildSummaryRow(
                  label: "Time",
                  value: bookingState.selectedTime ?? "Not selected",
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Reason for visit / symptoms",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 14),
          ),
          SizedBox(height: 10),
          AppTextField(
            controller: _notesController,
            hintText:
                "e.g. Experiencing headaches and dizziness for the past week.",
            maxLines: 6,
            maxLength: 300,
            keyboardType: TextInputType.multiline,
          ),
          Spacer(),
          PrimaryButton(
            text: "Review Booking",
            suffixIcon: LucideIcons.chevronRight,
            onPressed: () {
              ref
                  .read(appointmentBookingProvider.notifier)
                  .setNotes(_notesController.text);

              context.push(AppRoutes.bookAppointmentConfirm);
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
