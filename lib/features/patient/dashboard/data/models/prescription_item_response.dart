enum MedicineFrequency {
  morning,
  afternoon,
  night,
  morningNight,
  morningAfternoon,
  afternoonNight,
  morningAfternoonNight,
}

class PrescriptionItemResponse {
  final String itemId;
  final String medicineName;
  final String dosage;
  final int durationInDays;
  final MedicineFrequency frequency;
  final String instructions;

  const PrescriptionItemResponse({
    required this.itemId,
    required this.medicineName,
    required this.dosage,
    required this.durationInDays,
    required this.frequency,
    required this.instructions,
  });

  factory PrescriptionItemResponse.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemResponse(
      itemId: json['itemId'] as String,
      medicineName: json['medicineName'] as String,
      dosage: json['dosage'] as String,
      durationInDays: json['durationInDays'] as int,
      frequency: MedicineFrequency.values.firstWhere(
        (frequency) => frequency.name == json['frequency'],
      ),
      instructions: json['instructions'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'medicineName': medicineName,
      'dosage': dosage,
      'durationInDays': durationInDays,
      'frequency': frequency.name,
      'instructions': instructions,
    };
  }

  PrescriptionItemResponse copyWith({
    String? itemId,
    String? medicineName,
    String? dosage,
    int? durationInDays,
    MedicineFrequency? frequency,
    String? instructions,
  }) {
    return PrescriptionItemResponse(
      itemId: itemId ?? this.itemId,
      medicineName: medicineName ?? this.medicineName,
      dosage: dosage ?? this.dosage,
      durationInDays: durationInDays ?? this.durationInDays,
      frequency: frequency ?? this.frequency,
      instructions: instructions ?? this.instructions,
    );
  }
}