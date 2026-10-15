import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/data/models/update_appointment_status_model.dart';
import 'package:frontend/features/appointment/data/repo/appointment_repository.dart';
import 'package:frontend/features/appointment/providers/appointment_repo_provider.dart';

class AllAppointmentsNotifier extends AsyncNotifier<List<AppointmentResponse>> {
  late AppointmentRepository appointmentRepository;

  @override
  Future<List<AppointmentResponse>> build() async {
    appointmentRepository = ref.read(appointmentRepoProvider);

    final response = await appointmentRepository.getAllAppointments();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<AppointmentResponse> updateAppointmentStatus(
    UpdateAppointmentStatusRequest req,
    String appointmentId,
  ) async {
    try {
      final response = await appointmentRepository.updateAppointmentStatus(
        req,
        appointmentId,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      final updatedAppointment = response.data!;

      final currentAppointments = state.value ?? [];

      final updatedList = currentAppointments.map((appointment) {
        if (appointment.appointmentId == appointmentId) {
          return updatedAppointment;
        }

        return appointment;
      }).toList();

      state = AsyncData(updatedList);

      return updatedAppointment;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final allAppointmentsProvider =
    AsyncNotifierProvider<AllAppointmentsNotifier, List<AppointmentResponse>>(
      AllAppointmentsNotifier.new,
    );
