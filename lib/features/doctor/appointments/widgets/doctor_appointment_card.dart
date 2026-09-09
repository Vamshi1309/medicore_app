import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/features/doctor/appointments/widgets/appointment_info.dart';

import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final String patientName;
  final String initials;
  final String appointmentType;
  final int age;
  final String date;
  final String time;

  final AppointmentStatus status;

  final VoidCallback? onConfirm;
  final VoidCallback? onComplete;
  final VoidCallback? onPrescribe;

  const DoctorAppointmentCard({
    super.key,
    required this.patientName,
    required this.initials,
    required this.appointmentType,
    required this.age,
    required this.date,
    required this.time,
    required this.status,
    this.onConfirm,
    this.onComplete,
    this.onPrescribe,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          children: [
            // -------------------------
            // Patient info
            // -------------------------
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '$appointmentType · Age $age',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                _StatusBadge(status: status),
              ],
            ),

            const SizedBox(height: 12),

            // -------------------------
            // Date & Time
            // -------------------------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xffF7F9FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppointmentInfo(title: 'Date', value: date),
                  ),

                  Container(height: 32, width: 1, color: Colors.grey.shade300),

                  Expanded(
                    child: AppointmentInfo(title: 'Time', value: time),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // -------------------------
            // Buttons
            // -------------------------
            Row(
              children: [
                // Confirm only for pending appointments
                if (status == AppointmentStatus.pending) ...[
                  Expanded(
                    child: _OutlineButton(
                      text: 'Confirm',
                      onPressed: onConfirm,
                    ),
                  ),

                  const SizedBox(width: 6),
                ],

                Expanded(
                  child: _PrimaryButton(
                    text: 'Complete',
                    onPressed: onComplete,
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: _PrescribeButton(
                    text: 'Prescribe',
                    onPressed: onPrescribe,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _PrimaryButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return Colors.blue;
            }
            return Colors.blue;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppointmentStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: status.textColor,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _OutlineButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          foregroundColor: WidgetStateProperty.all(Colors.blue),
          side: WidgetStateProperty.all(
            const BorderSide(color: Colors.blue, width: 1),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _PrescribeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _PrescribeButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFFEAFBF4)),
          foregroundColor: WidgetStateProperty.all(const Color(0xFF0A9B68)),
          elevation: WidgetStateProperty.all(0),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
