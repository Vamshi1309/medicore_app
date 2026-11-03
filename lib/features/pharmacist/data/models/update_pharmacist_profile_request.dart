class UpdatePharmacistProfileRequest {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? licenseNumber;

  UpdatePharmacistProfileRequest({
    this.name,
    this.email,
    this.phoneNumber,
    this.licenseNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'licenseNumber': licenseNumber,
    };
  }
}