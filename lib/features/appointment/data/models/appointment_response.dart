import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class AppointmentResponse {
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialization;
  final String createdById;
  final String createdByName;
  final DateTime scheduledAt;
  final AppointmentStatus status;
  final String notes;
  final DateTime createdAt;

  AppointmentResponse({
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.createdById,
    required this.createdByName,
    required this.scheduledAt,
    required this.status,
    required this.notes,
    required this.createdAt,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      appointmentId: json['appointmentId'],
      patientId: json['patientId'],
      patientName: json['patientName'],
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      doctorSpecialization: json['doctorSpecialization'],
      createdById: json['createdById'],
      createdByName: json['createdByName'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      status: appointmentStatusFromString(json['status']),
      notes: json['notes'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'createdById': createdById,
      'createdByName': createdByName,
      'scheduledAt': scheduledAt.toIso8601String(),
      'status': appointmentStatusToString(status),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  AppointmentResponse copyWith({
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    String? createdById,
    String? createdByName,
    DateTime? scheduledAt,
    AppointmentStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return AppointmentResponse(
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization:
          doctorSpecialization ?? this.doctorSpecialization,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

AppointmentStatus appointmentStatusFromString(String status) {
  switch (status.toUpperCase()) {
    case 'PENDING':
      return AppointmentStatus.pending;

    case 'CONFIRMED':
      return AppointmentStatus.confirmed;

    case 'COMPLETED':
      return AppointmentStatus.completed;

    case 'CANCELLED':
      return AppointmentStatus.cancelled;

    case 'NO_SHOW':
      return AppointmentStatus.noShow;

    default:
      throw ArgumentError('Unknown appointment status: $status');
  }
}

String appointmentStatusToString(AppointmentStatus status) {
  switch (status) {
    case AppointmentStatus.pending:
      return 'PENDING';

    case AppointmentStatus.confirmed:
      return 'CONFIRMED';

    case AppointmentStatus.completed:
      return 'COMPLETED';

    case AppointmentStatus.cancelled:
      return 'CANCELLED';

    case AppointmentStatus.noShow:
      return 'NO_SHOW';
  }
}