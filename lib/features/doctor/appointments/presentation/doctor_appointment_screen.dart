import 'package:flutter/material.dart';
import 'package:frontend/features/doctor/appointments/widgets/doctor_appointment_card.dart';

class DoctorAppointmentScreen extends StatelessWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DoctorAppointmentCard(
              patientName: "Vamshi Dasari",
              initials: "VD",
              appointmentType: "Confirmed",
              age: 22,
              date: "13-09-2026",
              time: "1:45 Am",
              isConfirmed: false,
            ),
          ],
        ),
      ),
    );
  }
}
