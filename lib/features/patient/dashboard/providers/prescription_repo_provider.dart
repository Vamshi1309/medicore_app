import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/patient/dashboard/data/repos/prescription_repository.dart';

final prescriptionRepoProvider = Provider((ref) {
  return PrescriptionRepository(apiClient: ref.watch(apiClientProvider));
});
