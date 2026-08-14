import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/data/models/request/verify_register_otp.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/widgets/labelded_text_field.dart';
import 'package:frontend/features/auth/presentation/widgets/login_header.dart';
import 'package:frontend/features/auth/presentation/widgets/otp_verification_section.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool showOTP = false;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    return Scaffold(
      body: Column(
        children: [
          LoginHeader(displayText: "Create your MediCore Account"),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                AppCard(
                  child: Column(
                    children: [
                      LabeledTextField(
                        title: "Name",
                        hintText: "Enter your name",
                        controller: nameController,
                      ),
                      SizedBox(height: 20),
                      LabeledTextField(
                        title: "Phone Number",
                        hintText: "Enter your phone number",
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: phoneController,
                      ),
                      const SizedBox(height: 20),

                      LabeledTextField(
                        title: "Password",
                        hintText: "Enter your password",
                        controller: passwordController,
                        obscureText: true,
                        isPassword: true,
                        suffixIcon: Icons.remove_red_eye_outlined,
                      ),
                      SizedBox(height: 30),
                      if (!showOTP) ...[
                        PrimaryButton(text: "Send OTP", onPressed: sendOtp),
                      ] else ...[
                        OtpVerificationSection(
                          onGoBack: () {
                            setState(() {
                              showOTP = false;
                            });
                          },
                          onCompleted: (pin) async {
                            final success = await ref
                                .read(authProvider.notifier)
                                .verifyRegistrationOtp(
                                  VerifyRegistrationOtpRequest(
                                    name: nameController.text.trim(),
                                    phoneNumber: phoneController.text.trim(),
                                    password: passwordController.text.trim(),
                                    otp: pin,
                                  ),
                                );

                            if (!mounted) return;

                            if (success) {
                              goRouter.go(AppRoutes.login);
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        goRouter.go(AppRoutes.login);
                      },
                      child: Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.primary, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendOtp() async {
    final phoneNumber = phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your phone number")),
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .sendRegisterOtpRequest(phoneNumber);

    if (!mounted) return;

    if (success) {
      setState(() {
        showOTP = true;
      });
    }
  }
}
