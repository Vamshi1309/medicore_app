import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/data/repo/appointment_repository.dart';
import 'package:frontend/features/appointment/providers/appointment_repo_provider.dart';
import 'package:frontend/features/receptionist/book/presentation/models/book_appointment_model.dart';

final receptionistBookAppointmentProvider =
    Provider<ReceptionistBookAppointmentNotifier>((ref) {
      return ReceptionistBookAppointmentNotifier(
        ref,
        ref.read(appointmentRepoProvider),
      );
    });

class ReceptionistBookAppointmentNotifier {
  final Ref ref;
  final AppointmentRepository appointmentRepository;

  bool isCreatingAppointment = false;

  ReceptionistBookAppointmentNotifier(this.ref, this.appointmentRepository);

  Future<AppointmentResponse> createAppointment(
    CreateAppointmentRequest request,
  ) async {
    try {
      isCreatingAppointment = true;

      final response = await appointmentRepository
          .receptionistCreateAppointment(request);

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      return response.data!;
    } finally {
      isCreatingAppointment = false;
    }
  }
}
