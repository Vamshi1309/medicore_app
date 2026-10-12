class UpdateReceptionistProfileRequest {
  final String name;
  final String email;
  final String phoneNumber;

  const UpdateReceptionistProfileRequest({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }
}
