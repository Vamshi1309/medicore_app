import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/profile/data/models/update_patient_profile_request.dart';
import 'package:frontend/features/patient/profile/presentation/provider/patient_profile_provider.dart';
import 'package:frontend/features/patient/profile/widgets/profile_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _insuranceInfoController =
      TextEditingController();

  String? _selectedBloodGroup;

  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void initState() {
    super.initState();

    // Populate user fields
    final user = ref.read(authProvider).user;

    _nameController.text = user?.name ?? '';
    _phoneNumberController.text = user?.phoneNumber ?? '';

    // Listen to patient profile
    ref.listenManual(patientProfileProvider, (previous, next) {
      next.whenOrNull(
        data: (profile) {
          _dateOfBirthController.text = profile.dateOfBirth;
          _selectedBloodGroup = profile.bloodGroup;
          _emailController.text = profile.email;
          _emergencyContactController.text = profile.emergencyContact;
          _insuranceInfoController.text = profile.insuranceInfo;
        },
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : 'Something went wrong';

          AppSnackBar.error(context, message);
        },
      );
    }, fireImmediately: true);

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
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _emergencyContactController.dispose();
    _insuranceInfoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    // We watch it so the screen reacts to loading/error/data changes.
    //final profileAsync = ref.watch(patientProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                ProfileHeader(
                  name: user?.name ?? 'Patient',
                  role: user?.role.name ?? 'Patient',
                  isEditable: true,
                ),

                const SizedBox(height: 20),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardHeader(
                        icon: LucideIcons.user,
                        title: 'Personal Information',
                        bgColor: Colors.blue.shade100,
                        iconColor: Colors.blue.shade700,
                      ),

                      const SizedBox(height: 18),

                      _editTextRow(
                        title: 'Full Name',
                        controller: _nameController,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: 'Phone Number',
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: 'Email',
                        controller: _emailController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _cardHeader(
                        icon: LucideIcons.activity,
                        title: 'Medical Information',
                        bgColor: Colors.red.shade100,
                        iconColor: Colors.red.shade700,
                      ),

                      const SizedBox(height: 18),

                      _bloodGroupDropdown(),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: 'Date of Birth',
                        controller: _dateOfBirthController,
                        readOnly: true,
                        suffixIcon: LucideIcons.calendar,
                        onTap: _selectDateOfBirth,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: 'Emergency Contact',
                        controller: _emergencyContactController,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 8),

                      _editTextRow(
                        title: 'Insurance Policy Name',
                        controller: _insuranceInfoController,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveChanges(),
                    child: const Text('Save Changes'),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(goRouterProvider).pop();
                    },
                    child: const Text('Cancel'),
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
    bool readOnly = false,
    IconData? suffixIcon,
    VoidCallback? onTap,
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
          readOnly: readOnly,
          suffixIcon: suffixIcon,
          onTap: onTap,
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
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: bgColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(icon, color: iconColor, size: 18),
          ),
        ),

        const SizedBox(width: 12),

        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      _dateOfBirthController.text =
          '${pickedDate.day.toString().padLeft(2, '0')}-'
          '${pickedDate.month.toString().padLeft(2, '0')}-'
          '${pickedDate.year}';
    }
  }

  Widget _bloodGroupDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 5),
          child: Text(
            'Blood Group',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 5),

        DropdownButtonFormField<String>(
          initialValue: _selectedBloodGroup,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select blood group',
            hintStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
          items: _bloodGroups.map((bloodGroup) {
            return DropdownMenuItem<String>(
              value: bloodGroup,
              child: Text(
                bloodGroup,
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedBloodGroup = value;
            });
          },
        ),
      ],
    );
  }

  Future<void> _saveChanges() async {
    final profile = ref.read(patientProfileProvider).value;

    if (profile == null) {
      AppSnackBar.error(context, 'Unable to load your profile');
      return;
    }

    final request = UpdatePatientProfileRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneNumberController.text.trim(),
      dateOfBirth: _dateOfBirthController.text.trim(),
      bloodGroup: _selectedBloodGroup ?? '',
      emergencyContact: _emergencyContactController.text.trim(),
      insuranceInfo: _insuranceInfoController.text.trim(),
    );

    try {
      final message = await ref
          .read(patientProfileProvider.notifier)
          .updatePatientProfile(request);

      if (!mounted) return;

      AppSnackBar.success(context, message);

      ref.read(goRouterProvider).pop();
    } on ApiException catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, 'Something went wrong');
    }
  }
}
