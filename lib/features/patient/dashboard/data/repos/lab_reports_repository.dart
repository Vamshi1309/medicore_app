import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/patient/dashboard/data/models/lab_report_response.dart';

class LabReportsRepository {
  final ApiClient apiClient;

  const LabReportsRepository({required this.apiClient});

  Future<ApiResponse<List<LabReportResponse>>> getLabReportsByPatientId(
    String patientId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getLabReportsByPatientId(patientId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => LabReportResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }
}
