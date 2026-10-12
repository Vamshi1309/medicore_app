import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
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
    try {
      final response = await doctorProfileRepo.updateMyProfile(req);

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

      return response.data!;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: 'Something went wrong');
    }
  }
}

final doctorProfileProvider =
    AsyncNotifierProvider<DoctorProfileNotifier, DoctorProfileResponse>(
      DoctorProfileNotifier.new,
    );
