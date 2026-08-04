import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/auth/data/models/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/login_response.dart';
import 'package:frontend/features/auth/data/models/staff_login_request.dart';

class AuthRepository {
  final ApiClient apiClient;

  const AuthRepository({required this.apiClient});

  Future<ApiResponse<LoginResponse>> patientLogin(
    PatientLoginRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.patientLogin,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponse.formJson(data),
    );
  }

  Future<ApiResponse<LoginResponse>> staffLogin(
    StaffLoginRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.staffLogin,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponse.formJson(data),
    );
  }

  Future<ApiResponse<void>> logout() async {
    final respone = await apiClient.post(ApiConstants.logout);

    return ApiResponse.fromJson(respone.data, (_) {});
  }
}
