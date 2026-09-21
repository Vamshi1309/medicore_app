import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class UpdateAppointmentStatusRequest {
  final AppointmentStatus status;

  UpdateAppointmentStatusRequest({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.name.toUpperCase(),
    };
  }
}