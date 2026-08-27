import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/stepper/model/booking_step.dart';
import 'package:frontend/core/widgets/stepper/widget/booking_stepper.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/get_all_doctors_provider.dart';
import 'package:frontend/features/patient/dashboard/widgets/doctor_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  ConsumerState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  int currentStep = 0;

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
    final AsyncGetAllDoctors = ref.watch(getAllDoctorsProvider);

    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        leadingWidth: 75,
        leading: Center(
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.grey300,
            ),
            child: const Icon(
              LucideIcons.chevronLeft300,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),

        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Appointment",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "Step ${currentStep + 1} of ${bookingSteps.length}",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),

          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 12),
            decoration: const BoxDecoration(color: Colors.white),
            child: BookingStepper(currentStep: currentStep),
          ),

          const SizedBox(height: 20),

          // Doctor section + list
          Expanded(
            child: Padding(
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

                  // List takes all remaining space
                  Expanded(
                    child: AsyncGetAllDoctors.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stackTrace) {
                        return const Center(
                          child: Text('Unable to load doctors'),
                        );
                      },
                      data: (doctors) {
                        if (doctors.isEmpty) {
                          return const Center(
                            child: Text('No doctors available'),
                          );
                        }

                        return ListView.builder(
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];

                            return DoctorCard(
                              name: doctor.name,
                              experienceInYears: '${doctor.experienceInYears}',
                              speciality: doctor.specialization,
                              color: getDoctorAvatarColor(index),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Button stays at bottom
          Container(
            height: 60,
            padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
            decoration: BoxDecoration(color: Colors.white),
            child: PrimaryButton(
              text: "Continue",
              isTextBold: true,
              suffixIcon: LucideIcons.chevronRight,
              onPressed: () {
                setState(() {
                  currentStep++;
                });
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
