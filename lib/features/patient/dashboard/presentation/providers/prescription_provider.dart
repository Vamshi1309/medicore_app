import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/dashboard/data/models/prescription_response.dart';
import 'package:frontend/features/patient/dashboard/data/repos/prescription_repository.dart';
import 'package:frontend/features/patient/dashboard/providers/prescription_repo_provider.dart';

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
}

final prescriptionProvider =
    AsyncNotifierProvider<PrescriptionNotifier, List<PrescriptionResponse>>(
      PrescriptionNotifier.new,
    );
