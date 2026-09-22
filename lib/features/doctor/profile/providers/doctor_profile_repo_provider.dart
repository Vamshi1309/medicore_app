import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/doctor/profile/data/repo/doctor_profile_repo.dart';

final doctorProfileRepoProvider = Provider((ref) {
  return DoctorProfileRepo(apiClient: ref.watch(apiClientProvider));
});
