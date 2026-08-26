class UpdatePatientProfileRequest {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? bloodGroup;
  final String? emergencyContact;
  final String? insuranceInfo;

  UpdatePatientProfileRequest({
    this.name,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.bloodGroup,
    this.emergencyContact,
    this.insuranceInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "dateOfBirth": dateOfBirth,
      "bloodGroup": bloodGroup,
      "emergencyContact": emergencyContact,
      "insuranceInfo": insuranceInfo,
    };
  }

  UpdatePatientProfileRequest copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? bloodGroup,
    String? emergencyContact,
    String? insuranceInfo,
  }) {
    return UpdatePatientProfileRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      insuranceInfo: insuranceInfo ?? this.insuranceInfo,
    );
  }
}