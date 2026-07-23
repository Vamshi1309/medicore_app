import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class LoginHeader extends StatelessWidget {
  final bool isStaff;

  const LoginHeader({
    super.key,
    required this.isStaff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
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
              const Text(
                "MediCore",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isStaff
                    ? "Sign in as Hospital Staff"
                    : "Sign in to your MediCore account",
                style: const TextStyle(
                  color: AppColors.grey300,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}