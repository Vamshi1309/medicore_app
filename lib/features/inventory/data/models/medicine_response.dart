class MedicineResponse {
  final String id;
  final String medicineName;
  final int quantity;
  final String unit;
  final DateTime expiryDate;
  final double price;
  final String addedById;
  final String addedByName;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MedicineResponse({
    required this.id,
    required this.medicineName,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.price,
    required this.addedById,
    required this.addedByName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MedicineResponse.fromJson(Map<String, dynamic> json) {
    return MedicineResponse(
      id: json['id'] as String,
      medicineName: json['medicineName'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      price: (json['price'] as num).toDouble(),
      addedById: json['addedById'] as String,
      addedByName: json['addedByName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicineName': medicineName,
      'quantity': quantity,
      'unit': unit,
      'expiryDate': expiryDate.toIso8601String(),
      'price': price,
      'addedById': addedById,
      'addedByName': addedByName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}