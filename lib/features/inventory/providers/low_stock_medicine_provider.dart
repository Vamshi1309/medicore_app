import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';
import 'package:frontend/features/inventory/data/repo/inventory_repo.dart';
import 'package:frontend/features/inventory/providers/inventory_repo_provider.dart';

class LowStockMedicinesNotifier
    extends AsyncNotifier<List<MedicineResponse>> {
  late InventoryRepository inventoryRepository;

  @override
  Future<List<MedicineResponse>> build() async {
    inventoryRepository = ref.watch(inventoryRepoProvider);
    return [];
  }

  Future<List<MedicineResponse>> getLowStockMedicines({
    int threshold = 10,
  }) async {
    try {
      state = const AsyncLoading();

      final response = await inventoryRepository
          .getLowStockMedicines(threshold);

      if (response.data == null) {
        throw ApiException(message: response.message);
      }

      state = AsyncData(response.data!);
      return response.data!;
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}

final lowStockMedicinesProvider = AsyncNotifierProvider<
    LowStockMedicinesNotifier,
    List<MedicineResponse>>(
  LowStockMedicinesNotifier.new,
);