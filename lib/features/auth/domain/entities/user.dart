import 'package:frontend/shared/enums/user_role.dart';

class User {
  final String id;
  final String name;
  final String? phoneNumber;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.role,
  });
}