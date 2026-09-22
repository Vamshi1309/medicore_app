class UpdateDoctorProfileReq {
  final String? name;
  final String? specialization;
  final String? qualification;
  final int? experienceInYears;
  final String? email;
  final String? phoneNumber;
  final String? availabilityJson;

  const UpdateDoctorProfileReq({
    this.specialization,
    this.qualification,
    this.experienceInYears,
    this.availabilityJson,
    this.name,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "specialization": specialization,
      "qualification": qualification,
      "experienceInYears": experienceInYears,
      "email": email,
      "phoneNumber": phoneNumber,
      "availabilityJson": availabilityJson ?? "",
    };
  }
}
