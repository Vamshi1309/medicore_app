import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/prescription/data/models/create_prescription_request.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/data/models/update_prescription_request.dart';
import 'package:frontend/features/prescription/data/repo/prescription_repository.dart';
import 'package:frontend/features/prescription/providers/prescription_repo_provider.dart';

class PrescriptionNotifier extends AsyncNotifier<List<PrescriptionResponse>> {
  late PrescriptionRepository prescriptionRepository;

  @override
  Future<List<PrescriptionResponse>> build() async {
    prescriptionRepository = ref.read(prescriptionRepoProvider);

    final patientId = ref.read(authProvider).user!.id;

    final response = await prescriptionRepository.getPrescriptionsByPatientId(
      patientId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<PrescriptionResponse> getPrescriptionByAppointmentId(
    String appointmentId,
  ) async {
    final response = await prescriptionRepository
        .getPrescriptionByAppointmentId(appointmentId);

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<List<int>> downloadPrescriptionPdf(String prescriptionId) async {
    return prescriptionRepository.downloadPrescriptionPdf(prescriptionId);
  }

  Future<PrescriptionResponse> createPrescription(
    CreatePrescriptionRequest req,
  ) async {
    final response = await prescriptionRepository.createPrescription(req);

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<PrescriptionResponse> updatePrescription(
    UpdatePrescriptionRequest req,
    String prescriptionId,
  ) async {
    final response = await prescriptionRepository.updatePrescription(
      req,
      prescriptionId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    final updatedPrescription = response.data!;

    state = AsyncData(
      (state.value ?? []).map((prescription) {
        if (prescription.prescriptionId == prescriptionId) {
          return updatedPrescription;
        }

        return prescription;
      }).toList(),
    );

    return updatedPrescription;
  }
}

final prescriptionProvider =
    AsyncNotifierProvider<PrescriptionNotifier, List<PrescriptionResponse>>(
      PrescriptionNotifier.new,
    );
