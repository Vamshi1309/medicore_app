class UpdateDoctorProfileReq {
  final String specialization;
  final String qualification;
  final int experienceInYears;
  final String? availabilityJson;

  const UpdateDoctorProfileReq({
    required this.specialization,
    required this.qualification,
    required this.experienceInYears,
    this.availabilityJson,
  });

  Map<String, dynamic> toJson() {
    return {
      "specialization": specialization,
      "qualification": qualification,
      "experienceInYears": experienceInYears,
      "availabilityJson": availabilityJson ?? "",
    };
  }
}
