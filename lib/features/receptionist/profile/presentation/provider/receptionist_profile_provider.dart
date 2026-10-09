import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/receptionist/profile/data/model/receptionist_profile_response.dart';
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
}

final receptionistProfileProvider = AsyncNotifierProvider(
  ReceptionistProfileNotifier.new,
);
