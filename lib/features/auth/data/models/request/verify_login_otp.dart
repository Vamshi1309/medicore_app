class VerifyLoginOtpRequest {
  final String phoneNumber;
  final String otp;

  VerifyLoginOtpRequest({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'otp': otp,
    };
  }
}