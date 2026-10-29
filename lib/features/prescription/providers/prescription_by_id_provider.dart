
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/providers/prescription_repo_provider.dart';

final prescriptionByIdProvider =
    FutureProvider.family<PrescriptionResponse, String>(
  (ref, prescriptionId) async {
    final repo = ref.watch(prescriptionRepoProvider);

    final response =
        await repo.getPrescriptionByPrescriptionId(prescriptionId);

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  },
);
