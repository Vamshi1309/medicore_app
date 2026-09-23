import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/doctor/profile/providers/doctor_profile_provider.dart';
import 'package:frontend/features/widgets/profile/info_section.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DoctorProfileScreen extends ConsumerStatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  ConsumerState<DoctorProfileScreen> createState() =>
      _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends ConsumerState<DoctorProfileScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(doctorProfileProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err.toString();

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProfileAsync = ref.watch(doctorProfileProvider);
    final user = ref.watch(authProvider).user;
    final name = user?.name ?? "Doctor";
    final role = user?.role.name ?? "DOCTOR";
    final doctorId = user?.staffId ?? "";

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            ProfileHeader(name: name, role: role, isEditable: false),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  doctorProfileAsync.when(
                    error: (err, _) {
                      return ErrorState(
                        title: "Error",
                        subtitle: err.toString(),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    data: (data) {
                      return InfoSectionCard(
                        icon: LucideIcons.briefcaseMedical,
                        title: 'Medical Details',
                        rows: [
                          InfoRowData(label: 'Doctor ID', value: doctorId),
                          // From authProvider
                          InfoRowData(
                            label: 'Specialization',
                            value: data.specialization,
                          ),

                          // From authProvider
                          InfoRowData(
                            label: 'Qualification',
                            value: data.qualification,
                          ),
                          InfoRowData(
                            label: 'Experince',
                            value: '${data.experienceInYears} years',
                          ),
                          InfoRowData(label: 'Email', value: data.email),
                          InfoRowData(
                            label: 'Phone Number',
                            value: data.phoneNumber,
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  PrimaryButton.primary(
                    text: "Edit Profile",
                    prefixIcon: LucideIcons.edit,
                    onPressed: () {
                      context.push(AppRoutes.editDoctorProfile);
                    },
                  ),
                  SizedBox(height: 15),
                  PrimaryButton.outlinedFilled(
                    text: 'Logout',
                    prefixIcon: LucideIcons.logOut600,
                    color: Colors.red,
                    onPressed: () => ref.read(authProvider.notifier).logout(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
