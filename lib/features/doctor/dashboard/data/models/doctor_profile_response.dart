class DoctorProfileResponse {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String specialization;
  final String qualification;
  final int experienceInYears;
  final String? availabilityJson;

  const DoctorProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.specialization,
    required this.qualification,
    required this.experienceInYears,
    this.availabilityJson,
  });

  factory DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    return DoctorProfileResponse(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experienceInYears: json['experienceInYears'],
      availabilityJson: json['availabilityJson'],
    );
  }
}