import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/receptionist/profile/data/repo/receptionist_profile_repo.dart';

final receptionistProfileRepoProvider = Provider((ref) {
  return ReceptionistProfileRepo(apiClient: ref.watch(apiClientProvider));
});
