import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/api_response.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';

class AppointmentRepository {
  final ApiClient apiClient;

  const AppointmentRepository({required this.apiClient});

  Future<ApiResponse<List<AppointmentResponse>>> getPatientAppointments(
    String patientId,
  ) async {
    final response = await apiClient.get(
      ApiConstants.getAppointmentsByPatientId(patientId),
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => (data as List)
          .map((e) => AppointmentResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
