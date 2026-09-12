import 'package:frontend/features/prescription/data/models/prescription_item_request.dart';

class CreatePrescriptionRequest {
  final String appointmentId;
  final String? notes;
  final List<PrescriptionItemRequest> items;

  CreatePrescriptionRequest({
    required this.appointmentId,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
