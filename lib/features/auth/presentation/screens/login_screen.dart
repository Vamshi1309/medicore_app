import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 280,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "assets/images/login_bg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/logo/MediCoreLogoWhite.png",
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        "MediCore",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign in to your MediCore account",
                        style: TextStyle(
                          color: AppColors.grey300,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 14),
                            AppTextField(
                              hintText: "Enter your phone number",
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 14),
                            AppTextField(
                              hintText: "Enter your password",
                              obscureText: true,
                              isPassword: true,
                              suffixIcon: Icons.remove_red_eye_outlined,
                            ),
                            SizedBox(height: 24),
                            PrimaryButton(
                              text: "Login",
                              onPressed: () {
                                debugPrint("Will implement Navigation");
                              },
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    endIndent: 15,
                                    color: AppColors.grey500,
                                  ),
                                ),
                                Text("Or"),
                                Expanded(
                                  child: Divider(
                                    indent: 15,
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            PrimaryButton(
                              text: "Send OTP",
                              onPressed: () {
                                debugPrint("Will implement feature later");
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
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
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("Use staff ID for login"),
                              ],
                            ),
                            Spacer(flex: 10),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppColors.primary, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.grey),
                      children: [
                        const TextSpan(
                          text: "By continuing, you agree to our ",
                        ),
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint("Navigate to Terms of Service");
                            },
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              debugPrint("Navigate to Privacy Policy");
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
