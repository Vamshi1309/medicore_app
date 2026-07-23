import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/primary_button.dart';

import 'labelded_text_field.dart';

class StaffLoginForm extends StatelessWidget {
  final VoidCallback onLogin;

  const StaffLoginForm({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          title: "Staff ID",
          hintText: "Enter your staff ID",
        ),
        const SizedBox(height: 20),
        LabeledTextField(
          title: "Password",
          hintText: "Enter your password",
          obscureText: true,
          isPassword: true,
          suffixIcon: Icons.remove_red_eye_outlined,
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          text: "Login",
          onPressed: onLogin,
        ),
      ],
    );
  }
}