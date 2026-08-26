import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/profile/data/models/patient_profile_response.dart';
import 'package:frontend/features/patient/profile/data/models/update_patient_profile_request.dart';
import 'package:frontend/features/patient/profile/data/repos/patient_profile_repository.dart';
import 'package:frontend/features/patient/profile/providers/patient_profile_repo_provider.dart';

class PatientProfileNotifier extends AsyncNotifier<PatientProfileResponse> {
  late PatientProfileRepository patientProfileRepository;

  @override
  Future<PatientProfileResponse> build() async {
    patientProfileRepository = ref.read(patientProfileRepoProvider);

    final response = await patientProfileRepository.getPatientProfile();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }

  Future<String> updatePatientProfile(
    UpdatePatientProfileRequest request,
  ) async {
    try {
      final response = await patientProfileRepository.updatePatientProfile(
        request,
      );

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

final patientProfileProvider =
    AsyncNotifierProvider<PatientProfileNotifier, PatientProfileResponse>(
      PatientProfileNotifier.new,
    );
