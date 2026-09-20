import 'package:frontend/features/prescription/data/models/prescription_item_request.dart';

class UpdatePrescriptionRequest {
  final List<PrescriptionItemRequest> items;
  final String? notes;

  const UpdatePrescriptionRequest({required this.items, this.notes});

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'notes': notes,
    };
  }
}
