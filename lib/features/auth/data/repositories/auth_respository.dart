import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/auth/data/models/login_request.dart';
import 'package:frontend/features/auth/data/models/login_response.dart';

class AuthRepository {
  final ApiClient apiClient;

  const AuthRepository({required this.apiClient});

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    final response = await apiClient.post(
      ApiConstants.login,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponse.formJson(data),
    );
  }
}
