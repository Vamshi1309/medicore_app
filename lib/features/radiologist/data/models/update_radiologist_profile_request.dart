class UpdateRadiologistProfileRequest {
  final String? name;
  final String? phoneNumber;
  final String? labSection;
  final String? certification;

  const UpdateRadiologistProfileRequest({
    this.name,
    this.phoneNumber,
    this.labSection,
    this.certification,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'labSection': labSection,
      'certification': certification,
    };
  }
}
