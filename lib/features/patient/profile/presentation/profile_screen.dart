import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/profile/widgets/info_section.dart';
import 'package:frontend/features/patient/profile/widgets/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProfileHeader(name: 'Vamshi Garu', role: 'Patient'),
              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoSectionCard(
                      icon: LucideIcons.user600,
                      title: 'Personal Information',
                      rows: const [
                        InfoRowData(label: 'Full Name', value: 'Vamshi Garu'),
                        InfoRowData(label: 'Phone', value: '+91 98765 43210'),
                        InfoRowData(
                          label: 'Email',
                          value: 'vamshi.garu@email.com',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    InfoSectionCard(
                      icon: LucideIcons.activity600,
                      iconColor: Colors.red,
                      title: 'Medical Information',
                      rows: const [
                        InfoRowData(label: 'Blood Group', value: 'B+'),
                        InfoRowData(
                          label: 'Date of Birth',
                          value: '14 Mar 1992',
                        ),
                        InfoRowData(
                          label: 'Emergency Contact',
                          value: '+91 90000 12345',
                        ),
                        InfoRowData(
                          label: 'Insurance',
                          value: 'Star Health - POL-2024-00871',
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.lg),

                    // Reused PrimaryButton for Edit Profile
                    PrimaryButton(
                      text: 'Edit Profile',
                      icon: LucideIcons.pencil600,
                      onPressed: () {
                        
                      },
                    ),
                    const SizedBox(height: AppSizes.sm),

                    // PrimaryButton has no textColor prop, so it can't
                    // reproduce the light-red / red-text Logout style.
                    // Using a plain OutlinedButton here instead.
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          
                        },
                        icon: const Icon(LucideIcons.logOut600, color: Colors.red),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          side: BorderSide(color: Colors.red.shade100),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSizes.sm),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
