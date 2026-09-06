import 'package:flutter/material.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/stepper/widget/booking_stepper.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BookingShell extends StatelessWidget {
  final int currentStep;
  final Widget child;

  const BookingShell({
    super.key,
    required this.currentStep,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        leadingWidth: 75,
        leading: GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.patientHome);
            }
          },
          child: Center(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey300,
              ),
              child: const Icon(
                LucideIcons.chevronLeft300,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 70),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Appointment",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "Step ${currentStep + 1} of 5",
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.copyWith(color: AppColors.grey500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.only(left: 18, right: 18, top: 12),
            decoration: const BoxDecoration(color: Colors.white),
            child: BookingStepper(currentStep: currentStep),
          ),
          const SizedBox(height: 20),
          Expanded(child: child),
        ],
      ),
    );
  }
}
