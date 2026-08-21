import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/patient/dashboard/data/models/prescription_response.dart';

class PrescriptionRepository {
  final ApiClient apiClient;

  const PrescriptionRepository({required this.apiClient});

  Future<ApiResponse<List<PrescriptionResponse>>> getPrescriptionsByPatientId(
    String patientId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getPrescriptionsByPatientId(patientId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map(
              (e) => PrescriptionResponse.fromJson(e as Map<String, dynamic>),
            )
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
