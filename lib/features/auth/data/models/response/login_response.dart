import 'package:flutter/material.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponse.formJson(Map<String, dynamic> json) {
    debugPrint("LoginResponse JSON: $json");

    try {

      debugPrint("User parsed successfully");

      return LoginResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
      );
    } catch (e, st) {
      debugPrint("Parsing error: $e");
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
