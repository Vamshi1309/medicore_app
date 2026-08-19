class ApiConstants {
  ApiConstants._();

  static const String baseUrl = "http://192.168.1.11:8080/api";

  static const String patientLogin = "/auth/login";

  static const String staffLogin = "/auth/staff/login";

  static const String refreshToken = "/auth/refresh";

  static const String logout = "/auth/logout";

  static const String sendRegisterOtp = "/auth/register/send-otp";

  static const String verifyRegisterOtp = "/auth/register/verify-otp";

  static const String sendLoginOtp = "/auth/login/send-otp";

  static const String verifyLoginOtp = "/auth/login/verify-otp";

  static const String me = "/auth/me";
}
