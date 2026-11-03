class PharmacistProfileResponse {
  final String userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? licenseNumber;

  PharmacistProfileResponse({
    required this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.licenseNumber,
  });

  factory PharmacistProfileResponse.fromJson(Map<String, dynamic> json) {
    return PharmacistProfileResponse(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      licenseNumber: json['licenseNumber'] as String?,
    );
  }
}
