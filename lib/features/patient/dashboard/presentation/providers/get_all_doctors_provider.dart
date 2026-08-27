import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/doctor/data/models/doctor_profile_response.dart';
import 'package:frontend/features/doctor/data/repos/doctor_repository.dart';
import 'package:frontend/features/doctor/providers/get_all_doctors_repo.dart';

class GetAllDoctorsNotifier extends AsyncNotifier<List<DoctorProfileResponse>> {
  late GetAllDoctorsRepository getAllDoctorsRepository;
  @override
  Future<List<DoctorProfileResponse>> build() async {
    getAllDoctorsRepository = ref.read(getAllDoctorsRepoProvider);

    final response = await getAllDoctorsRepository.getAllDoctors();

    if (!response.success && response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final getAllDoctorsProvider =
    AsyncNotifierProvider<GetAllDoctorsNotifier, List<DoctorProfileResponse>>(
      GetAllDoctorsNotifier.new,
    );
