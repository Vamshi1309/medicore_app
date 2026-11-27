import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/labReports/data/models/create_lab_report_request.dart';
import 'package:frontend/features/labReports/data/models/lab_report_response.dart';

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

  Future<ApiResponse<String>> getDownloadUrl(String reportId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getLabReportDownloadUrl(reportId),
      );

      return ApiResponse.fromJson(response.data, (data) => data as String);
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

  Future<ApiResponse<LabReportResponse>> createLabReport(
    CreateLabReportRequest request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.labReports,
        data: await request.toFormData(),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => LabReportResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // GET /api/lab-reports/my
  Future<ApiResponse<List<LabReportResponse>>> getMyLabReports() async {
    try {
      final response = await apiClient.get(ApiConstants.getMyLabReports);

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => LabReportResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // GET /api/lab-reports/{id}
  Future<ApiResponse<LabReportResponse>> getLabReportById(String id) async {
    try {
      final response = await apiClient.get(ApiConstants.getLabReportById(id));

      return ApiResponse.fromJson(
        response.data,
        (data) => LabReportResponse.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _toApiException(e);
    }
  }

  // GET /api/lab-reports/appointment/{appointmentId}
  Future<ApiResponse<List<LabReportResponse>>> getLabReportsByAppointmentId(
    String appointmentId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getLabReportsByAppointmentId(appointmentId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => LabReportResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
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
