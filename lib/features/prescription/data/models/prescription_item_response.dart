import 'package:frontend/features/prescription/data/models/medicine_frequency.dart';

class PrescriptionItemResponse {
  final String itemId;
  final String? medicineId;
  final String? medicineName;
  final String? instructions;
  final String dosage;
  final int durationInDays;
  final MedicineFrequency frequency;
  final int quantity;
  final double pricePerUnit;

  const PrescriptionItemResponse({
    required this.itemId,
    this.medicineId,
    this.medicineName,
    required this.dosage,
    required this.durationInDays,
    required this.frequency,
    required this.quantity,
    required this.pricePerUnit,
    this.instructions,
  });

  factory PrescriptionItemResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemResponse(
      itemId: json['itemId'] as String,
      medicineId: json['medicineId'] as String?,
      medicineName: json['medicineName'] as String?,
      dosage: json['dosage'] as String,
      durationInDays: json['durationInDays'] as int,
      frequency: MedicineFrequencyExtension.fromApiValue(
        json['frequency'] as String,
      ),
      quantity: json['quantity'] as int,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      instructions: json['instructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'dosage': dosage,
      'durationInDays': durationInDays,
      'frequency': frequency.apiValue,
      'instructions': instructions,
      'pricePerUnit': pricePerUnit,
      'quantity': quantity,
    };
  }

  PrescriptionItemResponse copyWith({
    String? itemId,
    String? medicineId,
    String? medicineName,
    String? dosage,
    int? durationInDays,
    MedicineFrequency? frequency,
    int? quantity,
    double? pricePerUnit,
    String? instructions,
  }) {
    return PrescriptionItemResponse(
      itemId: itemId ?? this.itemId,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      durationInDays: durationInDays ?? this.durationInDays,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      instructions: instructions ?? this.instructions,
    );
  }
}
