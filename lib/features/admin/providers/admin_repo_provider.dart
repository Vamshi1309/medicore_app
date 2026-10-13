import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/admin/data/repo/admin_repo.dart';

final adminRepoProvider = Provider((ref) {
  return AdminRepo(apiClient: ref.watch(apiClientProvider));
});
