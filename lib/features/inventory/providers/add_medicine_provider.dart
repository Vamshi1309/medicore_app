import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/inventory/data/models/add_medicine_request.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';
import 'package:frontend/features/inventory/data/repo/inventory_repo.dart';
import 'package:frontend/features/inventory/providers/inventory_repo_provider.dart';

class AddMedicineNotifier extends AsyncNotifier<MedicineResponse?> {
  late InventoryRepository _inventoryRepository;

  @override
  Future<MedicineResponse?> build() async {
    _inventoryRepository = ref.read(inventoryRepoProvider);
    return null;
  }

  Future<MedicineResponse> addMedicine(AddMedicineRequest request) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final response = await _inventoryRepository.addMedicine(request);

      if (response.data == null) {
        throw ApiException(message: response.message);
      }

      return response.data!;
    });

    final medicine = state.value;
    if (medicine == null) {
      throw ApiException(message: 'Unable to add medicine');
    }

    return medicine;
  }
}

final addMedicineProvider =
    AsyncNotifierProvider<AddMedicineNotifier, MedicineResponse?>(
      AddMedicineNotifier.new,
    );
