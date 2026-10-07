import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/stepper/model/receptionist_booking_step.dart';

class ReceptionistBookingStepper extends StatelessWidget {
  final int currentStep;

  const ReceptionistBookingStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: List.generate(
          receptionistBookingSteps.length * 2 - 1,
          (index) {
            // STEP
            if (index.isEven) {
              final int stepIndex = index ~/ 2;

              final bool isActive = stepIndex <= currentStep;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Number circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? Colors.blue
                          : Colors.grey.shade300,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),

                  // Step name
                  Text(
                    receptionistBookingSteps[stepIndex].title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? Colors.blue
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }

            // CONNECTING LINE
            final int lineIndex = index ~/ 2;

            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                color: lineIndex < currentStep
                    ? Colors.blue
                    : Colors.grey.shade300,
              ),
            );
          },
        ),
      ),
    );
  }
}