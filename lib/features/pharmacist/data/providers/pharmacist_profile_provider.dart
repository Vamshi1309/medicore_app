import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/pharmacist/data/models/pharmacist_profile_response.dart';
import 'package:frontend/features/pharmacist/data/models/update_pharmacist_profile_request.dart';
import 'package:frontend/features/pharmacist/data/providers/pharmacist_profile_repo_provider.dart';
import 'package:frontend/features/pharmacist/data/repo/pharmacist_repository.dart';

class PharmacistProfileNotifier
    extends AsyncNotifier<PharmacistProfileResponse> {
  late PharmacistRepository pharmacistRepository;
  @override
  Future<PharmacistProfileResponse> build() async {
    pharmacistRepository = ref.watch(pharmacistProfileRepoProvider);

    final response = await pharmacistRepository.getPharmacistProfile();

    if (!response.success) {
      throw ApiException(message: response.message);
    }
    return response.data!;
  }

  Future<String> updatePharmacistProfile(
    UpdatePharmacistProfileRequest requestBody,
  ) async {
    try {
      state = const AsyncValue.loading();

      final response = await pharmacistRepository.updatePharmacistProfile(
        requestBody,
      );

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      state = AsyncValue.data(response.data!);

      ref.read(authProvider.notifier).updateUserProfile(
        name: response.data!.name ?? requestBody.name ?? 'Pharmacist',
        phoneNumber: response.data!.phoneNumber ?? requestBody.phoneNumber ?? '',
      );

      return response.message;
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(message: 'Something went wrong');
    }
  }
}

final pharmacistProfileProvider =
    AsyncNotifierProvider<PharmacistProfileNotifier, PharmacistProfileResponse>(
      PharmacistProfileNotifier.new,
    );
