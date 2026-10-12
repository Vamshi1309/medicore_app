import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/receptionist/profile/data/model/receptionist_profile_response.dart';
import 'package:frontend/features/receptionist/profile/data/model/update_receptionist_profile_req.dart';
import 'package:frontend/features/receptionist/profile/data/repo/receptionist_profile_repo.dart';
import 'package:frontend/features/receptionist/profile/providers/receptionist_profile_repo_provider.dart';

class ReceptionistProfileNotifier
    extends AsyncNotifier<ReceptionistProfileResponse> {
  late ReceptionistProfileRepo receptionistProfileRepo;

  @override
  Future<ReceptionistProfileResponse> build() async {
    receptionistProfileRepo = ref.watch(receptionistProfileRepoProvider);

    final response = await receptionistProfileRepo.getProfile();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<String> updateMyProfile(UpdateReceptionistProfileRequest req) async {
    try {
      final response = await receptionistProfileRepo.updateProfile(req);

      if (!response.success || response.data == null) {
        throw ApiException(message: response.message);
      }

      state = AsyncData(response.data!);

      ref
          .read(authProvider.notifier)
          .updateUserProfile(
            name: response.data!.name,
            phoneNumber: response.data!.phoneNumber,
          );

      return response.message;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }
}

final receptionistProfileProvider = AsyncNotifierProvider(
  ReceptionistProfileNotifier.new,
);
