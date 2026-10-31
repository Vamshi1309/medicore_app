import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';
import 'package:frontend/features/inventory/providers/inventory_repo_provider.dart';

final expiredMedicinesProvider =
    AsyncNotifierProvider<ExpiredMedicinesNotifier, List<MedicineResponse>>(
      ExpiredMedicinesNotifier.new,
    );

class ExpiredMedicinesNotifier extends AsyncNotifier<List<MedicineResponse>> {
  @override
  Future<List<MedicineResponse>> build() async {
    final response = await ref
        .read(inventoryRepoProvider)
        .getExpiredMedicines();

    return response.data!;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await ref
          .read(inventoryRepoProvider)
          .getExpiredMedicines();

      return response.data!;
    });
  }
}
