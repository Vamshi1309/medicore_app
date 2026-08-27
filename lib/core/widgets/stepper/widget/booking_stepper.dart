import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/stepper/model/booking_step.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BookingStepper extends StatelessWidget {
  final int currentStep;

  const BookingStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icons + connecting lines
        SizedBox(
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Connecting lines
              Row(
                children: List.generate(
                  bookingSteps.length - 1,
                  (index) {
                    return Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(
                          begin: 0,
                          end: index < currentStep ? 1 : 0,
                        ),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Container(
                            height: 2,
                            color: Color.lerp(
                              Colors.grey.shade300,
                              Colors.blue,
                              value,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              // Circles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  bookingSteps.length,
                  (stepIndex) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: stepIndex <= currentStep
                            ? Colors.blue
                            : Colors.grey.shade300,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        child: Icon(
                          stepIndex < currentStep
                              ? LucideIcons.check600
                              : bookingSteps[stepIndex].icon,
                          key: ValueKey(stepIndex < currentStep),
                          size: 16,
                          color: stepIndex <= currentStep
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            bookingSteps.length,
            (stepIndex) {
              return SizedBox(
                width: 35,
                child: Text(
                  bookingSteps[stepIndex].title,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: stepIndex <= currentStep
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: stepIndex <= currentStep
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}