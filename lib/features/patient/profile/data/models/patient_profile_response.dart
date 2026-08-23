class PatientProfileResponse {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String bloodGroup;
  final String emergencyContact;
  final String insuranceInfo;

  const PatientProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.bloodGroup,
    required this.emergencyContact,
    required this.insuranceInfo,
  });

  PatientProfileResponse copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? bloodGroup,
    String? emergencyContact,
    String? insuranceInfo,
  }) {
    return PatientProfileResponse(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      insuranceInfo: insuranceInfo ?? this.insuranceInfo,
    );
  }

  factory PatientProfileResponse.fromJson(Map<String, dynamic> json) {
    return PatientProfileResponse(
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      bloodGroup: json['bloodGroup'] as String,
      emergencyContact: json['emergencyContact'] as String,
      insuranceInfo: json['insuranceInfo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth,
      'bloodGroup': bloodGroup,
      'emergencyContact': emergencyContact,
      'insuranceInfo': insuranceInfo,
    };
  }
}
