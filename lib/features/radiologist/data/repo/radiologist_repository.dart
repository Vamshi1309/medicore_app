import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/radiologist/data/models/radiologist_profile_response.dart';
import 'package:frontend/features/radiologist/data/models/update_radiologist_profile_request.dart';

class RadiologistRepository {
  final ApiClient apiClient;

  const RadiologistRepository({required this.apiClient});

  Future<ApiResponse<RadiologistProfileResponse>> getProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.radiologistProfile);

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            RadiologistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  Future<ApiResponse<RadiologistProfileResponse>> updateProfile(
    UpdateRadiologistProfileRequest request,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.radiologistProfile,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            RadiologistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  ApiException _toApiException(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      final message = data['message'].toString().trim();
      if (message.isNotEmpty) return ApiException(message: message);
    }

    if (e.error is ApiException) return e.error as ApiException;

    return ApiException(message: 'Something went wrong');
  }
}
