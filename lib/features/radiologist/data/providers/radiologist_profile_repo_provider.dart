import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/radiologist/data/repo/radiologist_repository.dart';

final radiologistProfileRepoProvider = Provider<RadiologistRepository>((ref) {
  return RadiologistRepository(apiClient: ref.watch(apiClientProvider));
});
