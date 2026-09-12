import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/pharmacy/data/repos/pharmacy_repository.dart';

final pharmacyRepoProvider = Provider((ref) {
  return PharmacyRepository(apiClient: ref.watch(apiClientProvider));
});
