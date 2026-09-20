import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';

class InventoryRepository {
  final ApiClient apiClient;

  const InventoryRepository({required this.apiClient});

  Future<ApiResponse<List<MedicineResponse>>> getAllMedicines() async {
    try {
      final response = await apiClient.get(ApiConstants.getAllMedicines);

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => MedicineResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
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
