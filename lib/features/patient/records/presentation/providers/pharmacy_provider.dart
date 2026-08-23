import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/records/data/models/dispense_response.dart';
import 'package:frontend/features/patient/records/data/repositories/pharmacy_repository.dart';
import 'package:frontend/features/patient/records/providers/pharmacy_repo_provider.dart';

class PharmacyNotifier extends AsyncNotifier<List<DispenseResponse>> {
  late PharmacyRepository pharmacyRepository;

  @override
  Future<List<DispenseResponse>> build() async {
    pharmacyRepository = ref.read(pharmacyRepoProvider);

    final patientId = ref.read(authProvider).user!.id;

    final response = await pharmacyRepository.getDispenseHistory(patientId);

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final pharmacyProvider =
    AsyncNotifierProvider<PharmacyNotifier, List<DispenseResponse>>(
      PharmacyNotifier.new,
    );
