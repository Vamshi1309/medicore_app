import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_response.dart';
import 'package:frontend/features/pharmacy/data/repos/pharmacy_repository.dart';
import 'package:frontend/features/pharmacy/providers/pharmacy_repo_provider.dart';

class PharmacistDispenceHistoryNotifier
    extends AsyncNotifier<List<DispenseResponse>> {
  late PharmacyRepository pharmacyRepository;

  @override
  Future<List<DispenseResponse>> build() async {
    pharmacyRepository = ref.watch(pharmacyRepoProvider);

    final pharmacistId = ref.read(authProvider).user!.id;

    final response = await pharmacyRepository.getDispenseHistoryByPharmacistId(
      pharmacistId,
    );

    if (!response.success) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final pharmacistDispenceHistoryProvider =
    AsyncNotifierProvider<
      PharmacistDispenceHistoryNotifier,
      List<DispenseResponse>
    >(PharmacistDispenceHistoryNotifier.new);
