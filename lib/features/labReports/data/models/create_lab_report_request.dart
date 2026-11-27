import 'package:dio/dio.dart';
import 'package:frontend/features/labReports/data/enums/report_types_enum.dart';

class CreateLabReportRequest {
  final String appointmentId;
  final ReportType reportType;
  final String? findings;
  final String filePath;
  final String? fileName;

  const CreateLabReportRequest({
    required this.appointmentId,
    required this.reportType,
    this.findings,
    required this.filePath,
    this.fileName,
  });

  Future<FormData> toFormData() async {
    final trimmedFindings = findings?.trim();

    return FormData.fromMap({
      'appointmentId': appointmentId,
      'reportType': reportType.apiValue,
      if (trimmedFindings != null && trimmedFindings.isNotEmpty)
        'findings': trimmedFindings,
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
  }
}