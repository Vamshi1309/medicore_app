import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/patient/dashboard/data/models/lab_report_response.dart';
import 'package:frontend/features/patient/dashboard/data/repos/lab_reports_repository.dart';
import 'package:frontend/features/patient/dashboard/providers/lab_reports_repo_provider.dart';

class LabReportsNotifier extends AsyncNotifier<List<LabReportResponse>> {
  late LabReportsRepository labReportsRepository;

  @override
  Future<List<LabReportResponse>> build() async {
    labReportsRepository = ref.read(labReportsRepoProvider);

    final patientId = ref.read(authProvider).user!.id;

    final response = await labReportsRepository.getLabReportsByPatientId(
      patientId,
    );

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    return response.data!;
  }
}

final labReportsProvider =
    AsyncNotifierProvider<LabReportsNotifier, List<LabReportResponse>>(
      LabReportsNotifier.new,
    );
