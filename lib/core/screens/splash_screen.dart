import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 175, 213, 244), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 3),
            SizedBox(
              child: Transform.scale(
                scale: 1.6,
                child: Image.asset(
                  'assets/logo/MediCoreLogo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              "Medicore",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "Your Health Simplified",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.grey500,
              ),
            ),
            Spacer(flex: 1),
            _buildRow(
              context: context,
              icon: Icons.calendar_month_outlined,
              text: "Book appointments instantly",
            ),
            SizedBox(height: 16),
            _buildRow(
              context: context,
              icon: Icons.find_in_page_outlined,
              text: "Access your records",
            ),
            SizedBox(height: 16),
            _buildRow(
              context: context,
              icon: Icons.security_outlined,
              text: "Private & secure health data",
            ),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: LinearProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 7),
            Text(
              "Loading your profile....",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: 13),
            Text(
              "Version 0.0.1 . HIPAA Compliant",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.grey500,
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildRow({
    required BuildContext context,
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: const Color.fromARGB(255, 192, 222, 247),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 15,
            ),
          ),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
