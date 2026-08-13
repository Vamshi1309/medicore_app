import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationSection extends StatelessWidget {
  final VoidCallback onGoBack;
  final Future<void> Function(String) onCompleted;

  const OtpVerificationSection({
    super.key,
    required this.onGoBack,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Enter OTP",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Icon(Icons.chevron_left, size: 18, color: AppColors.primary),
            InkWell(
              onTap: onGoBack,
              child: const Text(
                "Go Back",
                style: TextStyle(fontSize: 12, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Pinput(
          length: 6,
          onCompleted: (pin) async {
            await onCompleted(pin);
          },
          defaultPinTheme: PinTheme(
            width: 48,
            height: 48,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey500),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 48,
            height: 48,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          submittedPinTheme: PinTheme(
            width: 48,
            height: 48,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
