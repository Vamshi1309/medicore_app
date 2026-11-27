import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/radiologist/data/models/radiologist_profile_response.dart';
import 'package:frontend/features/radiologist/data/models/update_radiologist_profile_request.dart';
import 'package:frontend/features/radiologist/data/providers/radiologist_profile_repo_provider.dart';
import 'package:frontend/features/radiologist/data/repo/radiologist_repository.dart';

class RadiologistProfileNotifier
    extends AsyncNotifier<RadiologistProfileResponse> {
  late RadiologistRepository _repository;

  @override
  Future<RadiologistProfileResponse> build() async {
    _repository = ref.watch(radiologistProfileRepoProvider);

    final response = await _repository.getProfile();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<String> updateProfile(UpdateRadiologistProfileRequest request) async {
    final previous = state;
    state = AsyncLoading<RadiologistProfileResponse>().copyWithPrevious(
      previous,
    );

    try {
      final response = await _repository.updateProfile(request);

      if (!response.success || response.data == null) {
        throw ApiException(
          message: response.message.isEmpty
              ? 'Could not update profile'
              : response.message,
        );
      }

      state = AsyncData(response.data!);

      final saved = response.data!;
      ref.read(authProvider.notifier).updateUserProfile(
            name: saved.name ?? request.name ?? '',
            phoneNumber: saved.phoneNumber ?? request.phoneNumber ?? '',
          );

      return response.message;
    } catch (error, stackTrace) {
      state = previous.hasValue
          ? AsyncData(previous.requireValue)
          : AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

final radiologistProfileProvider =
    AsyncNotifierProvider<
      RadiologistProfileNotifier,
      RadiologistProfileResponse
    >(RadiologistProfileNotifier.new, retry: (retryCount, error) => null);
