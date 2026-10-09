import 'package:frontend/features/receptionist/profile/data/model/shifts_enum.dart';

class ReceptionistProfileResponse {
  final String userId;
  final String name;
  final String email;
  final Shifts shift;
  final String phoneNumber;

  ReceptionistProfileResponse({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.shift,
  });

  factory ReceptionistProfileResponse.fromJson(Map<String, dynamic> json) {
    return ReceptionistProfileResponse(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      shift: Shifts.fromJson(json['shift'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "shift": shift.toJson(),
    };
  }
}
