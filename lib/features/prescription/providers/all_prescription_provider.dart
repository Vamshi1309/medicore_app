import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/data/repo/prescription_repository.dart';
import 'package:frontend/features/prescription/providers/prescription_repo_provider.dart';

class AllPrescriptionNotifier
    extends AsyncNotifier<List<PrescriptionResponse>> {
  late PrescriptionRepository repo;

  @override
  Future<List<PrescriptionResponse>> build() async {
    repo = ref.watch(prescriptionRepoProvider);

    final response = await repo.getAllPrescriptions();

    if (!response.success) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final getAllPrescriptionsProvider =
    AsyncNotifierProvider<AllPrescriptionNotifier, List<PrescriptionResponse>>(
      AllPrescriptionNotifier.new,
    );
