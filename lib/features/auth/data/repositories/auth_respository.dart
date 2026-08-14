import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/auth/data/models/request/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/request/send_otp_request.dart';
import 'package:frontend/features/auth/data/models/request/verify_login_otp.dart';
import 'package:frontend/features/auth/data/models/request/verify_register_otp.dart';
import 'package:frontend/features/auth/data/models/response/login_response.dart';
import 'package:frontend/features/auth/data/models/request/staff_login_request.dart';
import 'package:frontend/features/auth/data/models/response/otp_response.dart';

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

  Future<ApiResponse<OtpResponse>> sendRegistrationOtp(
    SendOtpRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.sendRegisterOtp,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => OtpResponse.fromJson(data),
    );
  }

  Future<ApiResponse<OtpResponse>> verifyRegistrationOtp(
    VerifyRegistrationOtpRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.verifyRegisterOtp,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => OtpResponse.fromJson(data),
    );
  }

  Future<ApiResponse<OtpResponse>> sendLoginOtp(SendOtpRequest request) async {
    final response = await apiClient.post(
      ApiConstants.sendLoginOtp,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => OtpResponse.fromJson(data),
    );
  }

  Future<ApiResponse<LoginResponse>> verifyLoginOtp(
    VerifyLoginOtpRequest request,
  ) async {
    final response = await apiClient.post(
      ApiConstants.verifyLoginOtp,
      data: request.toJson(),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => LoginResponse.formJson(data),
    );
  }
}
