import 'package:flutter/material.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/shared/enums/user_role.dart';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.formJson(Map<String, dynamic> json) {
    debugPrint("LoginResponse JSON: $json");

    try {
      final user = User(
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        role: UserRole.values.firstWhere(
          (role) => role.name.toUpperCase() == json['role'],
        ),
      );

      debugPrint("User parsed successfully");

      return LoginResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        user: user,
      );
    } catch (e, st) {
      debugPrint("Parsing error: $e");
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
