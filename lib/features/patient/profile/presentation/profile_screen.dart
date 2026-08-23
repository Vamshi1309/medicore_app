import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/profile/presentation/provider/patient_profile_provider.dart';
import 'package:frontend/features/patient/profile/widgets/info_section.dart';
import 'package:frontend/features/patient/profile/widgets/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(patientProfileProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : 'Something went wrong';

          AppSnackBar.error(context, message);
        },
      );
    });

    ref.listenManual(authProvider, (previous, next) {
      if (next.error != null) {
        AppSnackBar.error(context, next.error!);
      }

      if (next.message != null) {
        AppSnackBar.success(context, next.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(patientProfileProvider);

    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User data comes from authProvider
              ProfileHeader(
                name: user?.name ?? 'Patient',
                role: user?.role.name ?? 'Patient',
              ),

              Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    profileAsync.when(
                      loading: () => const _ProfileLoadingState(),

                      error: (error, stackTrace) {
                        final message = error is ApiException
                            ? error.message
                            : 'Unable to load your profile';

                        return _ProfileErrorState(
                          message: message,
                          onRetry: () {
                            ref.invalidate(patientProfileProvider);
                          },
                        );
                      },

                      data: (profile) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InfoSectionCard(
                              icon: LucideIcons.user600,
                              title: 'Personal Information',
                              rows: [
                                // From authProvider
                                InfoRowData(
                                  label: 'Full Name',
                                  value: user?.name ?? 'Not available',
                                ),

                                // From authProvider
                                InfoRowData(
                                  label: 'Phone',
                                  value: user?.phoneNumber ?? 'Not available',
                                ),

                                // From patientProfileProvider
                                InfoRowData(
                                  label: 'Email',
                                  value: profile.email,
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSizes.md),

                            InfoSectionCard(
                              icon: LucideIcons.activity600,
                              iconColor: Colors.red,
                              title: 'Medical Information',
                              rows: [
                                InfoRowData(
                                  label: 'Blood Group',
                                  value: profile.bloodGroup,
                                ),
                                InfoRowData(
                                  label: 'Date of Birth',
                                  value: profile.dateOfBirth,
                                ),
                                InfoRowData(
                                  label: 'Emergency Contact',
                                  value: profile.emergencyContact,
                                ),
                                InfoRowData(
                                  label: 'Insurance',
                                  value: profile.insuranceInfo,
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: AppSizes.lg),

                    PrimaryButton(
                      text: 'Edit Profile',
                      icon: LucideIcons.pencil600,
                      onPressed: () {
                        // Implement in next phase
                      },
                    ),

                    const SizedBox(height: AppSizes.sm),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                        },
                        icon: const Icon(
                          LucideIcons.logOut600,
                          color: Colors.red,
                        ),
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

class _ProfileLoadingState extends StatelessWidget {
  const _ProfileLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.xl),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _ProfileErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ProfileErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      child: Column(
        children: [
          Icon(
            LucideIcons.circleAlert600,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: AppSizes.md),
          const Text(
            'Unable to load profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSizes.md),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(LucideIcons.refreshCw600),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
