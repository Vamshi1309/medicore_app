import 'package:frontend/shared/enums/user_role.dart';

class User {
  final String id;
  final String? staffId;
  final String name;
  final String? phoneNumber;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    this.staffId,
    this.phoneNumber,
    required this.role,
  });

  User copyWith({
    String? id,
    String? name,
    String? staffId,
    String? phoneNumber,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      staffId: staffId ?? this.staffId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
    );
  }
}
