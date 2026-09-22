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
  late String name;
  late String role;
  late String doctorId;

  @override
  void initState() {
    super.initState();

    _loadProfileData();

    ref.listenManual(doctorProfileProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err.toString();

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  Future<void> _loadProfileData() async {
    final user = ref.watch(authProvider).user;

    name = user!.name;
    role = user.role.name;
    doctorId = user.staffId ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final doctorProfileAsync = ref.watch(doctorProfileProvider);

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statCard(title: 'Patients', count: '128'),
                      const SizedBox(width: 10),
                      _statCard(title: 'Appointments', count: '342'),
                      const SizedBox(width: 10),
                      _statCard(title: 'Prescription', count: '89'),
                    ],
                  ),

                  SizedBox(height: 15),
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

  Widget _statCard({required String title, required String count}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              title,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
