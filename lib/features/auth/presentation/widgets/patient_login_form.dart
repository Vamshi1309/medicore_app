import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/primary_button.dart';

import 'labelded_text_field.dart';
import 'otp_verification_section.dart';

class PatientLoginForm extends StatelessWidget {
  final bool showOtp;
  final VoidCallback onLogin;
  final VoidCallback onSendOtp;
  final VoidCallback onGoBack;
  final ValueChanged<String> onOtpCompleted;

  const PatientLoginForm({
    super.key,
    required this.showOtp,
    required this.onLogin,
    required this.onSendOtp,
    required this.onGoBack,
    required this.onOtpCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledTextField(
          title: "Phone Number",
          hintText: "Enter your phone number",
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),

        if (!showOtp) ...[
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

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Divider(
                  endIndent: 15,
                  color: AppColors.grey500,
                ),
              ),
              const Text("Or"),
              Expanded(
                child: Divider(
                  indent: 15,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          PrimaryButton(
            text: "Send OTP",
            onPressed: onSendOtp,
          ),
        ] else
          OtpVerificationSection(
            onGoBack: onGoBack,
            onCompleted: onOtpCompleted,
          ),
      ],
    );
  }
}