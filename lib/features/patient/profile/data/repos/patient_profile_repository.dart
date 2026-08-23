import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/patient/profile/data/models/patient_profile_response.dart';

class PatientProfileRepository {
  final ApiClient apiClient;

  const PatientProfileRepository({required this.apiClient});

  Future<ApiResponse<PatientProfileResponse>> getPatientProfile() async {
    try {
      final response = await apiClient.get(ApiConstants.getPatientProfile);

      return ApiResponse.fromJson(
        response.data,
        (data) => PatientProfileResponse.fromJson(data as Map<String, dynamic>),
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