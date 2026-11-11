class StaffSummaryResponse {
  final String userId;
  final String name;
  final String? staffId;
  final String? email;
  final String? phoneNumber;
  final String role;
  final bool? isActive;
  final DateTime? createdAt;

  const StaffSummaryResponse({
    required this.userId,
    required this.name,
    this.staffId,
    this.email,
    this.phoneNumber,
    required this.role,
    this.isActive,
    this.createdAt,
  });

  factory StaffSummaryResponse.fromJson(Map<String, dynamic> json) {
    return StaffSummaryResponse(
      userId: json['userId'] as String? ??
          (throw FormatException('userId is null')),
      name: json['name'] as String? ??
          (throw FormatException('name is null')),
      staffId: json['staffId'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber']?.toString(),
      role: json['role'] as String? ??
          (throw FormatException('role is null')),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }
}