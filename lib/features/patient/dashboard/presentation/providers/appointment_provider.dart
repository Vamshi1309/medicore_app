import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/data/repos/appointment_repository.dart';
import 'package:frontend/features/patient/dashboard/presentation/state/appointment_state.dart';
import 'package:frontend/features/patient/dashboard/providers/appointment_repo_provider.dart';

class PatientAppointmentNotifier
    extends AsyncNotifier<List<AppointmentResponse>> {
  late AppointmentRepository appointmentRepository;

  bool isCreatingAppointment = false;

  @override
  Future<List<AppointmentResponse>> build() async {
    appointmentRepository = ref.read(appointmentRepoProvider);
    final patientId = ref.read(authProvider).user!.id;

    final response = await appointmentRepository.getPatientAppointments(
      patientId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<AppointmentResponse> createAppointment(
    AppointmentBookingState booking,
  ) async {
    try {
      isCreatingAppointment = true;

      final patientId = ref.read(authProvider).user!.id;

      final response = await appointmentRepository.createAppointment(
        booking,
        patientId,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      final newAppointment = response.data!;

      state = AsyncData([...state.value ?? [], newAppointment]);

      return newAppointment;
    } finally {
      isCreatingAppointment = false;
    }
  }
}

final patientAppointmentsProvider =
    AsyncNotifierProvider<
      PatientAppointmentNotifier,
      List<AppointmentResponse>
    >(PatientAppointmentNotifier.new);
