class DispenseItemRequest {
  final String medicineId;
  final int quantityDispensed;

  const DispenseItemRequest({
    required this.medicineId,
    required this.quantityDispensed,
  });

  Map<String, dynamic> toJson() {
    return {
      'medicineId': medicineId,
      'quantityDispensed': quantityDispensed,
    };
  }
}