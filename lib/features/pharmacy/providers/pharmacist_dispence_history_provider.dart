import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_response.dart';
import 'package:frontend/features/pharmacy/providers/pharmacy_repo_provider.dart';

final pharmacistDispenceHistoryProvider =
    FutureProvider.autoDispose<List<DispenseResponse>>((ref) async {
  final authState = ref.watch(authProvider);

  if (!authState.isAuthenticated || authState.user == null) {
    return const [];
  }

  final pharmacyRepository = ref.watch(pharmacyRepoProvider);

  final response = await pharmacyRepository.getDispenseHistoryByPharmacistId(
    authState.user!.id,
  );

  if (!response.success) {
    throw ApiException(message: response.message);
  }

  return response.data ?? const [];
});
