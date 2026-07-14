import 'package:frontend/shared/enums/user_role.dart';

class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    required this.role,
  });
}