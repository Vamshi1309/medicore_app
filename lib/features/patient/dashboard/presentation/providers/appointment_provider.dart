import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/data/repos/appointment_repository.dart';
import 'package:frontend/features/patient/dashboard/providers/appointment_repo_provider.dart';

class PatientAppointmentNotifier
    extends AsyncNotifier<List<AppointmentResponse>> {
  late AppointmentRepository appointmentRepository;

  @override
  Future<List<AppointmentResponse>> build() async {
    appointmentRepository = ref.read(appointmentRepoProvider);
    final patientId = ref.read(authProvider).user!.id;

    final response = await appointmentRepository.getPatientAppointments(
      patientId,
    );

    if (!response.success || response.data == null) {
      throw Exception(response.message);
    }

    return response.data!;
  }
}

final patientAppointmentsProvider =
    AsyncNotifierProvider<
      PatientAppointmentNotifier,
      List<AppointmentResponse>
    >(PatientAppointmentNotifier.new);
