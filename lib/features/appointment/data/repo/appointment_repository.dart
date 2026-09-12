import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/presentation/state/appointment_state.dart';

class AppointmentRepository {
  final ApiClient apiClient;

  const AppointmentRepository({required this.apiClient});

  Future<ApiResponse<List<AppointmentResponse>>> getPatientAppointments(
    String patientId,
  ) async {
    try {
      final response = await apiClient.get(
        ApiConstants.getAppointmentsByPatientId(patientId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => (data as List)
            .map((e) => AppointmentResponse.fromJson(e as Map<String, dynamic>))
            .toList(),
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

  Future<ApiResponse<AppointmentResponse>> createAppointment(
    AppointmentBookingState booking,
    String patientId,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.createAppointment,
        data: booking.toJson(patientId),
      );

      return ApiResponse.fromJson(
        response.data,
        (data) => AppointmentResponse.fromJson(data as Map<String, dynamic>),
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
