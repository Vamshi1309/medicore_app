class PatientLoginRequest {
  final String phoneNumber;
  final String password;

  const PatientLoginRequest({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "password": password};
  }
}
