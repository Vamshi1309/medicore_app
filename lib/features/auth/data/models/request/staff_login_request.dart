class StaffLoginRequest {
  final String staffId;
  final String password;

  const StaffLoginRequest({required this.staffId, required this.password});

  Map<String, dynamic> toJson() {
    return {"staffId": staffId, "password": password};
  }
}
