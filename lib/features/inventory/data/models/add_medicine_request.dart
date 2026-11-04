class AddMedicineRequest {
  final String medicineName;
  final int quantity;
  final String unit;
  final String? expiryDate;
  final double? price;

  AddMedicineRequest({
    required this.medicineName,
    required this.quantity,
    required this.unit,
    this.expiryDate,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate,
      'price': price,
    };
  }
}
