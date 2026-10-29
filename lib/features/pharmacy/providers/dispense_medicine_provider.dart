import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_medicine_request.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_response.dart';
import 'package:frontend/features/pharmacy/data/repos/pharmacy_repository.dart';
import 'package:frontend/features/pharmacy/providers/pharmacy_repo_provider.dart';

class DispenseMedicineNotifier extends AsyncNotifier<DispenseResponse?> {
  late PharmacyRepository pharmacyRepository;

  @override
  Future<DispenseResponse?> build() async {
    pharmacyRepository = ref.watch(pharmacyRepoProvider);
    return null;
  }

  Future<DispenseResponse> dispenseMedicine(
    DispenseMedicineRequest request,
  ) async {
    state = const AsyncLoading();

    try {
      final response = await pharmacyRepository.dispenseMedicine(request);

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      state = AsyncData(response.data!);
      return response.data!;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final dispenseMedicineProvider =
    AsyncNotifierProvider<DispenseMedicineNotifier, DispenseResponse?>(
      DispenseMedicineNotifier.new,
    );
