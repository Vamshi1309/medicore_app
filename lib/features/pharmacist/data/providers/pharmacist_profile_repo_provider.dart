import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/pharmacist/data/repo/pharmacist_repository.dart';

final pharmacistProfileRepoProvider = Provider<PharmacistRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PharmacistRepository(apiClient: apiClient);
});
