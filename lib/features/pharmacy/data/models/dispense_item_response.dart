class DispenseItemResponse {
  final String dispenseId;
  final String medicineId;
  final String medicineName;

  final int quantityDispensed;
  final double pricePerUnit;
  final double totalPrice;

  const DispenseItemResponse({
    required this.dispenseId,
    required this.medicineId,
    required this.medicineName,
    required this.quantityDispensed,
    required this.pricePerUnit,
    required this.totalPrice,
  });

  DispenseItemResponse copyWith({
    String? dispenseId,
    String? medicineId,
    String? medicineName,
    int? quantityDispensed,
    double? pricePerUnit,
    double? totalPrice,
  }) {
    return DispenseItemResponse(
      dispenseId: dispenseId ?? this.dispenseId,
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      quantityDispensed: quantityDispensed ?? this.quantityDispensed,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory DispenseItemResponse.fromJson(Map<String, dynamic> json) {
    return DispenseItemResponse(
      dispenseId: json['dispenseId'] as String,
      medicineId: json['medicineId'] as String,
      medicineName: json['medicineName'] as String,
      quantityDispensed: json['quantityDispensed'] as int,
      pricePerUnit: (json['pricePerUnit'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dispenseId': dispenseId,
      'medicineId': medicineId,
      'medicineName': medicineName,
      'quantityDispensed': quantityDispensed,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
    };
  }
}