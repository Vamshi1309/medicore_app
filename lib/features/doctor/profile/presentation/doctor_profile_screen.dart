import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
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
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            ProfileHeader(
              name: "Vamshi Dasari",
              role: 'Doctor',
              isEditable: false,
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  InfoSectionCard(
                    icon: LucideIcons.briefcaseMedical,
                    title: 'Medical Details',
                    rows: [
                      // From authProvider
                      InfoRowData(
                        label: 'Specialization',
                        value: 'cardiologist',
                      ),

                      // From authProvider
                      InfoRowData(label: 'Qualification', value: 'MBBS, MD'),
                      InfoRowData(label: 'Experince', value: '12 years'),
                      InfoRowData(
                        label: 'Hospital',
                        value: 'Lilavathi hospitals',
                      ),

                      // From patientProfileProvider
                      InfoRowData(label: 'Email', value: "doctor@gmail.com  "),
                    ],
                  ),
                  SizedBox(height: 15),
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
