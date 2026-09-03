import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_booking_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/get_all_doctors_provider.dart';
import 'package:frontend/features/patient/dashboard/widgets/doctor_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SelectDoctorStep extends ConsumerStatefulWidget {
  const SelectDoctorStep({super.key});

  @override
  ConsumerState<SelectDoctorStep> createState() => _SelectDoctorStepState();
}

class _SelectDoctorStepState extends ConsumerState<SelectDoctorStep> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(getAllDoctorsProvider, (prev, next) {
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
    final asyncDoctors = ref.watch(getAllDoctorsProvider);
    final selectedDoctorId = ref.watch(
      appointmentBookingProvider.select((s) => s.doctorId),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select a Doctor",
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 5),
          const Text(
            "Choose your preferred specialist",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: asyncDoctors.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  const Center(child: Text('Unable to load doctors')),
              data: (doctors) {
                if (doctors.isEmpty) {
                  return const Center(child: Text('No doctors available'));
                }
                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final isSelected = selectedDoctorId == doctor.userId;

                    return DoctorCard(
                      name: doctor.name,
                      experienceInYears: '${doctor.experienceInYears}',
                      speciality: doctor.specialization,
                      color: getDoctorAvatarColor(index),
                      isSelected: isSelected,
                      onTap: () {
                        ref
                            .read(appointmentBookingProvider.notifier)
                            .setDoctor(doctor.userId);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.only(top: 10),
            child: PrimaryButton(
              text: "Continue",
              isTextBold: true,
              suffixIcon: LucideIcons.chevronRight,
              enabled: selectedDoctorId != null,
              color: selectedDoctorId != null
                  ? AppColors.primary
                  : AppColors.grey300,
              onPressed: () {
                context.push('${AppRoutes.bookAppointment}/date');
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Color getDoctorAvatarColor(int index) {
    const colors = [
      Color(0xFFE3F2FD),
      Color(0xFFE8F5E9),
      Color(0xFFFFF3E0),
      Color(0xFFF3E5F5),
      Color(0xFFFFEBEE),
      Color(0xFFE0F7FA),
      Color(0xFFFFFDE7),
      Color(0xFFEDE7F6),
      Color(0xFFFBE9E7),
      Color(0xFFE0F2F1),
    ];
    return colors[index % colors.length];
  }
}
