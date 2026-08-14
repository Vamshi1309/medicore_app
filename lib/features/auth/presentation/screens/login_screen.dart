import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/features/auth/data/models/request/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/request/verify_login_otp.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/widgets/patient_login_form.dart';
import 'package:frontend/features/auth/presentation/widgets/staff_login_form.dart';
import '../../../../core/providers/go_router_provider.dart';
import '../widgets/login_header.dart';
import '../widgets/terms_and_privacy_text.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isStaff = false;
  bool showOtp = false;
  String? otpPhoneNumber;

  @override
  void initState() {
    super.initState();

    ref.listenManual(authProvider, (prev, next) {
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
    final goRouter = ref.watch(goRouterProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LoginHeader(displayText: "Sign in to your MediCore account"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      AppCard(
                        child: isStaff
                            ? StaffLoginForm(
                                onLogin: () {
                                  debugPrint(
                                    "+++++++++++++++ Will implement Navigation +++++++++++++",
                                  );
                                },
                              )
                            : PatientLoginForm(
                                showOtp: showOtp,
                                onLogin: onTapLogin,
                                onSendOtp: (phoneNumber) async {
                                  await sendOtp(phoneNumber);
                                },
                                onGoBack: () {
                                  setState(() {
                                    showOtp = false;
                                    otpPhoneNumber = null;
                                  });
                                },
                                onOtpCompleted: (pin) async {
                                  await verifyOtp(pin);
                                },
                              ),
                      ),
                      SizedBox(height: 25),
                      if (!isStaff)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isStaff = true;
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.grey300,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                width: 1.5,
                                color: AppColors.grey500,
                              ),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Spacer(flex: 1),
                                CircleAvatar(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    205,
                                    205,
                                    205,
                                  ),
                                  child: Icon(
                                    Icons.badge_outlined,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Spacer(flex: 2),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hospital Staff member?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text("Use staff ID for login"),
                                  ],
                                ),
                                Spacer(flex: 10),
                                Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (!isStaff)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Dont have an account?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () {
                            goRouter.go(AppRoutes.register);
                          },
                          child: Text(
                            "Create Account",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                ),
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, size: 16),
                        SizedBox(width: 6),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: "Are you a Patient?"),
                              TextSpan(
                                text: " Go back",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    setState(() => isStaff = false);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: isStaff || showOtp ? 150 : 20),
                  TermsAndPrivacyText(
                    onTermsTap: () {
                      debugPrint("Navigate to Terms of Service");
                    },
                    onPrivacyTap: () {
                      debugPrint("Navigate to Privacy Policy");
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTapLogin(String phoneNumber, String password) {
    ref
        .read(authProvider.notifier)
        .patientLogin(
          PatientLoginRequest(phoneNumber: phoneNumber, password: password),
        );
  }

  Future<void> sendOtp(String phoneNumber) async {
    final success = await ref
        .read(authProvider.notifier)
        .sendLoginOtp(phoneNumber);

    if (!mounted) return;

    if (success) {
      setState(() {
        otpPhoneNumber = phoneNumber;
        showOtp = true;
      });
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otpPhoneNumber == null) {
      AppSnackBar.error(
        context,
        "Phone number is missing. Please request OTP again.",
      );
      return;
    }

    final success = await ref
        .read(authProvider.notifier)
        .verifyLoginOtp(
          VerifyLoginOtpRequest(phoneNumber: otpPhoneNumber!, otp: otp),
        );

    if (!mounted) return;

    if (success) {
      final goRouter = ref.read(goRouterProvider);

      goRouter.go(AppRoutes.home);
    }
  }
}
