import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/doctor/profile/data/models/update_doctor_profile_req.dart';
import 'package:frontend/features/doctor/profile/providers/doctor_profile_provider.dart';
import 'package:frontend/features/widgets/profile/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditDoctorProfileScreen extends ConsumerStatefulWidget {
  const EditDoctorProfileScreen({super.key});

  @override
  ConsumerState<EditDoctorProfileScreen> createState() =>
      _EditDoctorProfileScreenState();
}

class _EditDoctorProfileScreenState
    extends ConsumerState<EditDoctorProfileScreen> {
  final _fullNameController = TextEditingController();
  final _specializationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadProfileData();

    ref.listenManual(doctorProfileProvider, (previous, next) {
      next.when(
        data: (data) {
          _specializationController.text = data.specialization;
          _qualificationController.text = data.qualification;
          _experienceController.text = data.experienceInYears.toString();
          _emailController.text = data.email;
          _phoneNumberController.text = data.phoneNumber;
        },
        loading: () {},
        error: (error, stackTrace) {
          AppSnackBar.error(context, error.toString());
        },
      );
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    final user = ref.watch(authProvider).user;
    _fullNameController.text = user!.name;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ProfileHeader(
                  name: user?.name ?? "Doctor",
                  role: user?.role.name ?? "DOCTOR",
                  isEditable: true,
                ),

                const SizedBox(height: 20),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardHeader(
                        icon: LucideIcons.stethoscope,
                        title: "Professional Information",
                        bgColor: Colors.teal.shade100,
                        iconColor: Colors.teal.shade700,
                      ),

                      const SizedBox(height: 18),

                      _editTextRow(
                        title: "Full Name",
                        controller: _fullNameController,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: "Specialization",
                        controller: _specializationController,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: "Qualification",
                        controller: _qualificationController,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: "Experience",
                        controller: _experienceController,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 8),
                      _editTextRow(
                        title: "Email",
                        controller: _emailController,
                      ),

                      const SizedBox(height: 8),
                      _editTextRow(
                        title: "Phone Number",
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    child: const Text("Save Changes"),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => ref.read(goRouterProvider).pop(),
                    child: const Text("Cancel"),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editTextRow({
    required String title,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 5),

        AppTextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
        ),
      ],
    );
  }

  Widget _cardHeader({
    required IconData icon,
    required String title,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),

        const SizedBox(width: 12),

        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Future<void> _saveChanges() async {
    final req = UpdateDoctorProfileReq(
      name: _fullNameController.text,
      specialization: _specializationController.text,
      qualification: _qualificationController.text,
      experienceInYears: int.parse(_experienceController.text),
      phoneNumber: _phoneNumberController.text,
      email: _emailController.text,
    );

    await ref.read(doctorProfileProvider.notifier).updateMyProfile(req);

    ref.read(goRouterProvider).pop();
  }
}
