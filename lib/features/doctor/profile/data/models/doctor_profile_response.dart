class DoctorProfileResponse {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String specialization;
  final String qualification;
  final int experienceInYears;
  final String availabilityJson;

  const DoctorProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.specialization,
    required this.qualification,
    required this.experienceInYears,
    required this.availabilityJson,
  });

  factory DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    return DoctorProfileResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      specialization: json['specialization'] as String,
      qualification: json['qualification'] as String,
      experienceInYears: json['experienceInYears'] as int,
      availabilityJson: json['availabilityJson'] as String,
    );
  }
}
