import 'dispense_item_response.dart';

class DispenseResponse {
  final String prescriptionId;

  final String patientId;
  final String patientName;

  final String dispensedById;
  final String dispensedByName;

  final List<DispenseItemResponse> items;

  // Bill
  final double totalAmount;

  final String notes;
  final DateTime dispensedAt;

  const DispenseResponse({
    required this.prescriptionId,
    required this.patientId,
    required this.patientName,
    required this.dispensedById,
    required this.dispensedByName,
    required this.items,
    required this.totalAmount,
    required this.notes,
    required this.dispensedAt,
  });

  DispenseResponse copyWith({
    String? prescriptionId,
    String? patientId,
    String? patientName,
    String? dispensedById,
    String? dispensedByName,
    List<DispenseItemResponse>? items,
    double? totalAmount,
    String? notes,
    DateTime? dispensedAt,
  }) {
    return DispenseResponse(
      prescriptionId: prescriptionId ?? this.prescriptionId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      dispensedById: dispensedById ?? this.dispensedById,
      dispensedByName: dispensedByName ?? this.dispensedByName,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      dispensedAt: dispensedAt ?? this.dispensedAt,
    );
  }

  factory DispenseResponse.fromJson(Map<String, dynamic> json) {
    return DispenseResponse(
      prescriptionId: json['prescriptionId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      dispensedById: json['dispensedById'] as String,
      dispensedByName: json['dispensedByName'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => DispenseItemResponse.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      notes: json['notes'] as String,
      dispensedAt: DateTime.parse(json['dispensedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prescriptionId': prescriptionId,
      'patientId': patientId,
      'patientName': patientName,
      'dispensedById': dispensedById,
      'dispensedByName': dispensedByName,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'notes': notes,
      'dispensedAt': dispensedAt.toIso8601String(),
    };
  }
}