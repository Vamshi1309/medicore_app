import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class AppointmentModel {
  final String doctorName;
  final String specialty;
  final DateTime appointmentDateTime;
  final AppointmentStatus status;

  AppointmentModel({
    required this.doctorName,
    required this.specialty,
    required this.appointmentDateTime,
    required this.status,
  });
}
