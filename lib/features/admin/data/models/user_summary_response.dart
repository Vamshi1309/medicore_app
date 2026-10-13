class UserSummaryResponse {
  final String userId;
  final String name;
  final String? email;
  final String? phoneNumber;
  final String? staffId;
  final String role;
  final bool? isActive;
  final DateTime? createdAt;
  final String? tempPassword;

  const UserSummaryResponse({
    required this.userId,
    required this.name,
    this.email,
    this.phoneNumber,
    this.staffId,
    required this.role,
    this.isActive,
    this.createdAt,
    this.tempPassword,
  });

  factory UserSummaryResponse.fromJson(Map<String, dynamic> json) {
    return UserSummaryResponse(
      userId:
          json['userId'] as String? ??
          (throw FormatException('userId is null')),
      name: json['name'] as String? ?? (throw FormatException('name is null')),
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber']?.toString(),
      staffId: json['staffId'] as String?,
      role: json['role'] as String? ?? (throw FormatException('role is null')),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      tempPassword: json['tempPassword'] as String?,
    );
  }
}
