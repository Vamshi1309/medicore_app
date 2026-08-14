import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/shared/enums/user_role.dart';

class UserProfileResponse {
  final String id;
  final String name;
  final String phoneNumber;
  final String role;

  const UserProfileResponse({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.role,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      phoneNumber: phoneNumber,
      role: UserRole.values.firstWhere(
        (role) => role.name.toUpperCase() == this.role,
      ),
    );
  }
}
