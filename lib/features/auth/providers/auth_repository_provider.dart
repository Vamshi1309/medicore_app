import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/auth/data/repositories/auth_respository.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(apiClient: ref.watch(apiClientProvider));
});
