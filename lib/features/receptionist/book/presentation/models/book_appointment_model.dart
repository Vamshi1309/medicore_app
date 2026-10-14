class CreateAppointmentRequest {
  final String patientId;
  final String doctorId;
  final DateTime scheduledAt;
  final String? notes;

  const CreateAppointmentRequest({
    required this.patientId,
    required this.doctorId,
    required this.scheduledAt,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'notes': notes,
    };
  }
}
