import 'package:frontend/features/prescription/data/models/medicine_frequency.dart';

class PrescriptionItemRequest {
  final String medicineName;
  final String dosage;
  final int durationDays;
  final MedicineFrequency frequency;
  final String? instructions;

  PrescriptionItemRequest({
    required this.medicineName,
    required this.dosage,
    required this.durationDays,
    required this.frequency,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'dosage': dosage,
      'durationDays': durationDays,
      'frequency': frequency.apiValue,
      'instructions': instructions,
    };
  }
}
