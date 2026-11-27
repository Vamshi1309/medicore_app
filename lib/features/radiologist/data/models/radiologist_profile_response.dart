class RadiologistProfileResponse {
  final String userId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? labSection;
  final String? certification;

  const RadiologistProfileResponse({
    required this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.labSection,
    this.certification,
  });

  factory RadiologistProfileResponse.fromJson(Map<String, dynamic> json) {
    return RadiologistProfileResponse(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      labSection: json['labSection'] as String?,
      certification: json['certification'] as String?,
    );
  }
}
