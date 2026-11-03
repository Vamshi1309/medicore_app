import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/providers/prescription_repo_provider.dart';

final getAllPrescriptionsProvider =
    FutureProvider.autoDispose<List<PrescriptionResponse>>((ref) async {
  final authState = ref.watch(authProvider);

  if (!authState.isAuthenticated || authState.user == null) {
    return const [];
  }

  final repo = ref.watch(prescriptionRepoProvider);
  final response = await repo.getAllPrescriptions();

  if (!response.success) {
    throw ApiException(message: response.message);
  }

  return response.data ?? const [];
});
