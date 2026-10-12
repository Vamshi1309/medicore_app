import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/receptionist/profile/data/model/receptionist_profile_response.dart';
import 'package:frontend/features/receptionist/profile/data/model/update_receptionist_profile_req.dart';

class ReceptionistProfileRepo {
  final ApiClient apiClient;

  const ReceptionistProfileRepo({required this.apiClient});

  Future<ApiResponse<ReceptionistProfileResponse>> getProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.receptionistProfile);

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            ReceptionistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(message: data['message'] ?? "Something went wrong");
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }

  Future<ApiResponse<ReceptionistProfileResponse>> updateProfile(
    UpdateReceptionistProfileRequest req,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.receptionistProfile,
        data: req.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) =>
            ReceptionistProfileResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(message: data['message'] ?? "Something went wrong");
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }
}
