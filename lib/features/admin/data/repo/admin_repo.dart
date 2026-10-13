import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/admin/data/models/user_summary_response.dart';

class AdminRepo {
  final ApiClient apiClient;

  const AdminRepo({required this.apiClient});

  Future<ApiResponse<List<UserSummaryResponse>>> getAllUsers() async {
    try {
      final response = await apiClient.get(
        ApiConstants.getAllUsers,
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map(
              (e) => UserSummaryResponse.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList(),
      );
    } on DioException catch (e) {
      if (e.response?.data != null) {
        final data = e.response!.data;

        throw ApiException(
          message: data['message'] ?? 'Something went wrong',
        );
      }

      if (e.error is ApiException) {
        throw e.error as ApiException;
      }

      throw ApiException(message: 'Something went wrong');
    }
  }
}
