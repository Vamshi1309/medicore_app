import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/features/doctor/appointments/widgets/appointment_info.dart';

class DoctorAppointmentCard extends StatelessWidget {
  final String patientName;
  final String initials;
  final String appointmentType;
  final int age;
  final String date;
  final String time;
  final bool isConfirmed;

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
    required this.isConfirmed,
    this.onConfirm,
    this.onComplete,
    this.onPrescribe,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
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
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),

              _StatusBadge(isConfirmed: isConfirmed),
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
              // Show Confirm ONLY when not confirmed
              if (!isConfirmed) ...[
                Expanded(
                  child: _OutlineButton(text: 'Confirm', onPressed: onConfirm),
                ),

                const SizedBox(width: 6),
              ],

              Expanded(
                child: _PrimaryButton(text: 'Complete', onPressed: onComplete),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  final bool isConfirmed;

  const _StatusBadge({required this.isConfirmed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isConfirmed ? const Color(0xffEEF5FF) : const Color(0xfffff8e6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isConfirmed ? 'Confirmed' : 'Pending',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isConfirmed ? Colors.blue : Colors.orange,
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _OutlineButton({
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blue,
          padding: EdgeInsets.zero,
          side: const BorderSide(
            color: Colors.blue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PrescribeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const _PrescribeButton({
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffEAFBF4),
          foregroundColor: const Color(0xff0A9B68),
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}