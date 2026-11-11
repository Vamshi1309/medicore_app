class PatientSummaryResponse {
  final String userId;
  final String name;
  final String? phoneNumber;
  final String? email;
  final bool? isActive;
  final DateTime? createdAt;

  const PatientSummaryResponse({
    required this.userId,
    required this.name,
    this.phoneNumber,
    this.email,
    this.isActive,
    this.createdAt,
  });

  factory PatientSummaryResponse.fromJson(Map<String, dynamic> json) {
    return PatientSummaryResponse(
      userId: json['userId'] as String? ??
          (throw FormatException('userId is null')),
      name: json['name'] as String? ??
          (throw FormatException('name is null')),
      phoneNumber: json['phoneNumber']?.toString(),
      email: json['email'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }
}
