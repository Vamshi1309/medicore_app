import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';

import 'labelded_text_field.dart';
import 'otp_verification_section.dart';

class PatientLoginForm extends StatefulWidget {
  final bool showOtp;
  final void Function(String phone, String password) onLogin;
  final void Function(String phone) onSendOtp;
  final VoidCallback onGoBack;
  final Future<void> Function(String) onOtpCompleted;

  const PatientLoginForm({
    super.key,
    required this.showOtp,
    required this.onLogin,
    required this.onSendOtp,
    required this.onGoBack,
    required this.onOtpCompleted,
  });

  @override
  State<PatientLoginForm> createState() => _PatientLoginFormState();
}

class _PatientLoginFormState extends State<PatientLoginForm> {
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          title: "Phone Number",
          controller: phoneController,
          hintText: "Enter your phone number",
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        if (!widget.showOtp) ...[
          LabeledTextField(
            title: "Password",
            controller: passwordController,
            hintText: "Enter your password",
            obscureText: true,
            isPassword: true,
            suffixIcon: Icons.remove_red_eye_outlined,
          ),
          const SizedBox(height: 24),

          PrimaryButton(
            text: "Login",
            onPressed: () {
              widget.onLogin(
                phoneController.text.trim(),
                passwordController.text.trim(),
              );
            },
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: Divider(endIndent: 15, color: AppColors.grey500)),
              const Text("Or"),
              Expanded(child: Divider(indent: 15, color: AppColors.grey500)),
            ],
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: "Send OTP",
            onPressed: () {
              widget.onSendOtp(phoneController.text.trim());
            },
          ),
        ] else
          OtpVerificationSection(
            onGoBack: widget.onGoBack,
            onCompleted: widget.onOtpCompleted,
          ),
      ],
    );
  }
}
