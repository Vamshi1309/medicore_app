import 'package:frontend/features/prescription/data/models/medicine_frequency.dart';

class PrescriptionItemRequest {
  final String medicineId;
  final String dosage;
  final int durationDays;
  final MedicineFrequency frequency;
  final String? instructions;

  PrescriptionItemRequest({
    required this.medicineId,
    required this.dosage,
    required this.durationDays,
    required this.frequency,
    this.instructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'dosage': dosage,
      'durationDays': durationDays,
      'frequency': frequency.apiValue,
      'instructions': instructions,
    };
  }
}