import 'prescription_item_response.dart';

class PrescriptionResponse {
  final String prescriptionId;
  final String appointmentId;

  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;

  final String patientId;
  final String patientName;

  final String notes;

  final List<PrescriptionItemResponse> items;

  final DateTime createdAt;

  const PrescriptionResponse({
    required this.prescriptionId,
    required this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    required this.patientId,
    required this.patientName,
    required this.notes,
    required this.items,
    required this.createdAt,
  });

  factory PrescriptionResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionResponse(
      prescriptionId: json['prescriptionId'] as String,
      appointmentId: json['appointmentId'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialization: json['doctorSpecialization'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      notes: json['notes'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (item) => PrescriptionItemResponse.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'patientId': patientId,
      'patientName': patientName,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  PrescriptionResponse copyWith({
    String? prescriptionId,
    String? appointmentId,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialization,
    String? patientId,
    String? patientName,
    String? notes,
    List<PrescriptionItemResponse>? items,
    DateTime? createdAt,
  }) {
    return PrescriptionResponse(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialization:
          doctorSpecialization ?? this.doctorSpecialization,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      notes: notes ?? this.notes,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}