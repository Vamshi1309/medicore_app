import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_booking_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';

class SelectTimeStep extends ConsumerStatefulWidget {
  const SelectTimeStep({super.key});

  @override
  ConsumerState<SelectTimeStep> createState() => _SelectTimeStepState();
}

class _SelectTimeStepState extends ConsumerState<SelectTimeStep> {
  static const List<String> _morningSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
  ];

  static const List<String> _afternoonSlots = [
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(
      appointmentBookingProvider.select((s) => s.selectedDate),
    );
    final selectedTime = ref.watch(
      appointmentBookingProvider.select((s) => s.selectedTime),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a Time",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Available time slots for your choosen date",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          if (selectedDate != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.calendar,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('EEE, MMMM d, yyyy').format(selectedDate),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Morning"),
                  const SizedBox(height: 10),
                  _timeGrid(_morningSlots, selectedTime),

                  const SizedBox(height: 20),

                  _sectionLabel("Afternoon"),
                  const SizedBox(height: 10),
                  _timeGrid(_afternoonSlots, selectedTime),
                ],
              ),
            ),
          ),

          Container(
            height: 60,
            padding: const EdgeInsets.only(top: 10),
            child: PrimaryButton(
              text: "Continue",
              isTextBold: true,
              suffixIcon: LucideIcons.chevronRight,
              enabled: selectedTime != null,
              color: selectedTime != null
                  ? AppColors.primary
                  : AppColors.grey300,
              onPressed: () {
                context.push(AppRoutes.bookAppointmentNotes);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _timeGrid(List<String> slots, String? selectedTime) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.4,
      ),
      itemBuilder: (context, index) {
        final slot = slots[index];
        final isSelected = slot == selectedTime;

        return GestureDetector(
          onTap: () {
            ref.read(appointmentBookingProvider.notifier).setTime(slot);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
