import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/doctor/dashboard/data/models/doctor_profile_response.dart';

class GetAllDoctorsRepository {
  final ApiClient apiClient;

  const GetAllDoctorsRepository({required this.apiClient});

  Future<ApiResponse<List<DoctorProfileResponse>>> getAllDoctors() async {
    try {
      final response = await apiClient.get(ApiConstants.getAllDoctors);

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map(
              (e) => DoctorProfileResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } on DioException catch (e) {
      // If backend returned an ApiResponse with a message
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(message: data['message'] ?? "Something went wrong");
      }

      // Already converted elsewhere
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }
}
