import 'package:frontend/core/providers/network_providers.dart';
import 'package:frontend/features/labReports/data/repos/lab_reports_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'lab_reports_repository_provider.g.dart';

@riverpod
LabReportsRepository labReportsRepo(Ref ref) {
  return LabReportsRepository(
    apiClient: ref.watch(apiClientProvider),
  );
}