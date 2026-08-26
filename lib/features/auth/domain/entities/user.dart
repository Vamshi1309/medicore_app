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

  User copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }
}
