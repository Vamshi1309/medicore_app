import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/doctor/dashboard/data/models/doctor_profile_response.dart';
import 'package:frontend/features/doctor/profile/data/models/update_doctor_profile_req.dart';

class DoctorProfileRepo {
  final ApiClient apiClient;

  const DoctorProfileRepo({required this.apiClient});

  Future<ApiResponse<DoctorProfileResponse>> getMyProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.doctorProfile);

      return ApiResponse.fromJson(
        response.data,
        (data) => DoctorProfileResponse.fromJson(data as Map<String, dynamic>),
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

  Future<ApiResponse<DoctorProfileResponse>> updateMyProfile(
    UpdateDoctorProfileReq req,
  ) async {
    try {
      final response = await apiClient.put(
        ApiConstants.doctorProfile,
        data: req.toJson(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => DoctorProfileResponse.fromJson(data as Map<String, dynamic>),
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
