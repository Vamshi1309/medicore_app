import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/appointment/data/models/update_appointment_status_model.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/data/repo/appointment_repository.dart';
import 'package:frontend/features/patient/dashboard/presentation/state/appointment_state.dart';
import 'package:frontend/features/appointment/providers/appointment_repo_provider.dart';

class AppointmentNotifier extends AsyncNotifier<List<AppointmentResponse>> {
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

    final appointments = response.data!;

    state = AsyncData(appointments);

    return appointments;
  }

  // ============================================================
  // CREATE APPOINTMENT
  // ============================================================

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

  // ============================================================
  // GET ALL APPOINTMENTS
  // ============================================================

  Future<List<AppointmentResponse>> getAllAppointments() async {
    final response = await appointmentRepository.getAllAppointments();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    final appointments = response.data!;

    state = AsyncData(appointments);

    return appointments;
  }

  // ============================================================
  // GET DOCTOR APPOINTMENTS
  // ============================================================

  Future<List<AppointmentResponse>> getAppointmentsByDoctorId() async {
    final doctorId = ref.read(authProvider).user!.id;

    final response = await appointmentRepository.getDoctorAppointments(
      doctorId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    final appointments = response.data!;

    state = AsyncData(appointments);

    return appointments;
  }

  // ============================================================
  // GET APPOINTMENT BY ID
  // ============================================================

  Future<AppointmentResponse> getAppointmentByAppointmentId(
    String appointmentId,
  ) async {
    final response = await appointmentRepository.getByAppointmentId(
      appointmentId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  // ============================================================
  // UPDATE APPOINTMENT STATUS
  // ============================================================

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

final appointmentsProvider =
    AsyncNotifierProvider<AppointmentNotifier, List<AppointmentResponse>>(
      AppointmentNotifier.new,
    );
