import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/admin/data/models/patient_summary_response.dart';
import 'package:frontend/features/receptionist/data/repo/receptionist_profile_repo.dart';
import 'package:frontend/features/receptionist/providers/receptionist_profile_repo_provider.dart';

class ReceptionistPatientsProvider
    extends AsyncNotifier<List<PatientSummaryResponse>> {
  late ReceptionistProfileRepo receptionistProfileRepo;

  @override
  Future<List<PatientSummaryResponse>> build() async {
    receptionistProfileRepo = ref.watch(receptionistProfileRepoProvider);

    final response = await receptionistProfileRepo.getAllPatients();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final receptionistPatientsProvider =
    AsyncNotifierProvider<
      ReceptionistPatientsProvider,
      List<PatientSummaryResponse>
    >(ReceptionistPatientsProvider.new);
