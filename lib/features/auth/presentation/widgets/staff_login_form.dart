import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';

import 'labelded_text_field.dart';

class StaffLoginForm extends StatefulWidget {
  final void Function(String phone, String password) onLogin;

  const StaffLoginForm({super.key, required this.onLogin});

  @override
  State<StaffLoginForm> createState() => _StaffLoginFormState();
}

class _StaffLoginFormState extends State<StaffLoginForm> {
  late final TextEditingController staffIdController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    staffIdController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    staffIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          title: "Staff ID",
          controller: staffIdController,
          hintText: "Enter your staff ID",
        ),
        const SizedBox(height: 20),
        LabeledTextField(
          title: "Password",
          controller: passwordController,
          hintText: "Enter your password",
          obscureText: true,
          isPassword: true,
          suffixIcon: Icons.remove_red_eye_outlined,
        ),
        const SizedBox(height: 24),
        PrimaryButton.primary(
          text: "Login",
          onPressed: () {
            if (staffIdController.text.isEmpty &&
                passwordController.text.isEmpty) {
              AppSnackBar.error(context, "Please fill required fields");
            }
            if (staffIdController.text.isEmpty) {
              AppSnackBar.error(context, "Please provide staffId");
            }

            if (passwordController.text.isEmpty) {
              AppSnackBar.error(context, "Please provide password");
            }
            widget.onLogin(
              staffIdController.text.trim(),
              passwordController.text.trim(),
            );
          },
        ),
      ],
    );
  }
}
