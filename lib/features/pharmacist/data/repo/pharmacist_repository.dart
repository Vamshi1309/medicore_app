import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/pharmacist/data/models/pharmacist_profile_response.dart';
import 'package:frontend/features/pharmacist/data/models/update_pharmacist_profile_request.dart';

class PharmacistRepository {
  final ApiClient apiClient;

  const PharmacistRepository({required this.apiClient});

  Future<ApiResponse<PharmacistProfileResponse>> getPharmacistProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.pharmacistProfile);

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            PharmacistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        throw ApiException(message: data['message'] ?? "Something went wrong");
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }

  Future<ApiResponse<PharmacistProfileResponse>> updatePharmacistProfile(
    UpdatePharmacistProfileRequest requestBody,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.pharmacistProfile,
        data: requestBody.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            PharmacistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;

        throw ApiException(message: data['message'] ?? "Something went wrong");
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }
}
