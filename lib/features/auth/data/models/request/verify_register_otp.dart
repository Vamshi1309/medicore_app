class VerifyRegistrationOtpRequest {
  final String name;
  final String phoneNumber;
  final String password;
  final String otp;

  VerifyRegistrationOtpRequest({
    required this.name,
    required this.phoneNumber,
    required this.password,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'otp': otp,
    };
  }
}