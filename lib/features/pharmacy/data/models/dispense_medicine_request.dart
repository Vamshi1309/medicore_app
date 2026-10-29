import 'dispense_item_request.dart';

class DispenseMedicineRequest {
  final String prescriptionId;
  final List<DispenseItemRequest> items;
  final String? notes;

  const DispenseMedicineRequest({
    required this.prescriptionId,
    required this.items,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }
}