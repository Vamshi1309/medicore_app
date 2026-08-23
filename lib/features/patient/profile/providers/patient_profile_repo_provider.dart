import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/patient/profile/data/repos/patient_profile_repository.dart';

final patientProfileRepoProvider = Provider((ref) {
  return PatientProfileRepository(apiClient: ref.watch(apiClientProvider));
});
