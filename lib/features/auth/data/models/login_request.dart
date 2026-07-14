class LoginRequest {
  final String phoneNumber;
  final String password;

  const LoginRequest({required this.phoneNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {"phoneNumber": phoneNumber, "password": password};
  }
}
