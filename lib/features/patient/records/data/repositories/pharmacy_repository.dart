import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/patient/records/data/models/dispense_response.dart';

class PharmacyRepository {
  final ApiClient apiClient;

  const PharmacyRepository({required this.apiClient});

  Future<ApiResponse<List<DispenseResponse>>> getDispenseHistory(
    String patientId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getDispenseHistoryByPatientId(patientId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => DispenseResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } on DioException catch (e) {
      if (e is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: "Something went wrong");
    }
  }
}
