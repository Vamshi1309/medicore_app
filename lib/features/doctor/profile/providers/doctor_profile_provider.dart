import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/doctor/dashboard/data/models/doctor_profile_response.dart';
import 'package:frontend/features/doctor/profile/data/models/update_doctor_profile_req.dart';
import 'package:frontend/features/doctor/profile/data/repo/doctor_profile_repo.dart';
import 'package:frontend/features/doctor/profile/providers/doctor_profile_repo_provider.dart';

class DoctorProfileNotifier extends AsyncNotifier<DoctorProfileResponse> {
  late DoctorProfileRepo doctorProfileRepo;

  @override
  Future<DoctorProfileResponse> build() async {
    doctorProfileRepo = ref.watch(doctorProfileRepoProvider);

    final response = await doctorProfileRepo.getMyProfile();

    if (response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<DoctorProfileResponse> updateMyProfile(
    UpdateDoctorProfileReq req,
  ) async {
    state = const AsyncLoading();

    try {
      final response = await doctorProfileRepo.updateMyProfile(req);

      if (response.data == null) {
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

final doctorProfileProvider =
    AsyncNotifierProvider<DoctorProfileNotifier, DoctorProfileResponse>(
      DoctorProfileNotifier.new,
    );
