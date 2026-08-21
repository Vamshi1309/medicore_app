import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/auth/data/models/request/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/request/send_otp_request.dart';
import 'package:frontend/features/auth/data/models/request/staff_login_request.dart';
import 'package:frontend/features/auth/data/models/request/verify_login_otp.dart';
import 'package:frontend/features/auth/data/models/request/verify_register_otp.dart';
import 'package:frontend/features/auth/data/models/response/login_response.dart';
import 'package:frontend/features/auth/data/models/response/otp_response.dart';
import 'package:frontend/features/auth/data/models/response/user_profile_response.dart';

class AuthRepository {
  final ApiClient apiClient;

  const AuthRepository({required this.apiClient});

  Future<ApiResponse<LoginResponse>> patientLogin(
    PatientLoginRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.patientLogin,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => LoginResponse.formJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<LoginResponse>> staffLogin(
    StaffLoginRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.staffLogin,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => LoginResponse.formJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await apiClient.post(ApiConstants.logout);

      return ApiResponse.fromJson(response.data, (_) {});
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<OtpResponse>> sendRegistrationOtp(
    SendOtpRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.sendRegisterOtp,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => OtpResponse.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<OtpResponse>> verifyRegistrationOtp(
    VerifyRegistrationOtpRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyRegisterOtp,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => OtpResponse.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<OtpResponse>> sendLoginOtp(SendOtpRequest request) async {
    try {
      final response = await apiClient.post(
        ApiConstants.sendLoginOtp,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => OtpResponse.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<LoginResponse>> verifyLoginOtp(
    VerifyLoginOtpRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyLoginOtp,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => LoginResponse.formJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Future<ApiResponse<UserProfileResponse>> getMe() async {
    try {
      final response = await apiClient.get(ApiConstants.me);

      return ApiResponse.fromJson(
        response.data,
        (data) => UserProfileResponse.fromJson(data),
      );
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  Never _handleDioException(DioException e) {
    if (e.error is ApiException) {
      throw e.error as ApiException;
    }

    throw ApiException(message: 'Something went wrong.');
  }
}
