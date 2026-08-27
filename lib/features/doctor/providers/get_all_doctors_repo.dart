import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/doctor/data/repos/doctor_repository.dart';

final getAllDoctorsRepoProvider = Provider((ref) {
  return GetAllDoctorsRepository(apiClient: ref.watch(apiClientProvider));
});
