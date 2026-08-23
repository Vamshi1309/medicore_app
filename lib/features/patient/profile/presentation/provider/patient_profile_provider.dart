import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/patient/profile/data/models/patient_profile_response.dart';
import 'package:frontend/features/patient/profile/data/repos/patient_profile_repository.dart';
import 'package:frontend/features/patient/profile/providers/patient_profile_repo_provider.dart';

class PatientProfileNotifier extends AsyncNotifier<PatientProfileResponse> {
  late PatientProfileRepository patientProfileRepository;

  @override
  Future<PatientProfileResponse> build() async {
    patientProfileRepository = ref.read(patientProfileRepoProvider);

    final response = await patientProfileRepository.getPatientProfile();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final patientProfileProvider =
    AsyncNotifierProvider<PatientProfileNotifier, PatientProfileResponse>(
      PatientProfileNotifier.new,
    );