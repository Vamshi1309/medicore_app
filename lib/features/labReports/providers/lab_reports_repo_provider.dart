import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/labReports/data/repos/lab_reports_repository.dart';

final labReportsRepoProvider = Provider((ref) {
  return LabReportsRepository(apiClient: ref.watch(apiClientProvider));
});
