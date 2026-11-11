import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/admin/data/models/patient_summary_response.dart';
import 'package:frontend/features/admin/data/models/staff_summary_response.dart';

class AdminRepo {
  final ApiClient apiClient;

  const AdminRepo({required this.apiClient});

  Future<ApiResponse<List<StaffSummaryResponse>>> getAllStaff() async {
    try {
      final response = await apiClient.get(ApiConstants.getAllStaff);

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map(
              (e) => StaffSummaryResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(message: data['message'] ?? 'Something went wrong');
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: 'Something went wrong');
    }
  }

  Future<ApiResponse<List<PatientSummaryResponse>>> getAllPatients() async {
    try {
      final response = await apiClient.get(ApiConstants.receptionistGetAllPatients);

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map(
              (e) => PatientSummaryResponse.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(message: data['message'] ?? 'Something went wrong');
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: 'Something went wrong');
    }
  }
}
