import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_booking_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectDateStep extends ConsumerWidget {
  const SelectDateStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate =
        ref.watch(appointmentBookingProvider.select((s) => s.selectedDate));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a Date",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Choose your preferred appointment date",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: AppColors.primary,      // selected day + header
                      onPrimary: Colors.white,          // text on selected day
                      onSurface: Colors.black87,        // default day text
                    ),
                textTheme: Theme.of(context).textTheme.copyWith(
                      titleMedium: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
              ),
              child: CalendarDatePicker(
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
                currentDate: DateTime.now(),
                onDateChanged: (date) {
                  ref.read(appointmentBookingProvider.notifier).setDate(date);
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                  const Icon(LucideIcons.calendar, color: AppColors.primary, size: 18),
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

          const Spacer(),

          Container(
            height: 60,
            padding: const EdgeInsets.only(top: 10),
            child: PrimaryButton(
              text: "Continue",
              isTextBold: true,
              suffixIcon: LucideIcons.chevronRight,
              enabled: selectedDate != null,
              color: selectedDate != null ? AppColors.primary : AppColors.grey300,
              onPressed: () {
                context.push(AppRoutes.bookAppointmentTime);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}