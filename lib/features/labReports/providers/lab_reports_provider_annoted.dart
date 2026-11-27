import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/features/labReports/data/models/create_lab_report_request.dart';
import 'package:frontend/features/labReports/data/models/lab_report_response.dart';
import 'package:frontend/features/labReports/providers/lab_reports_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lab_reports_provider_annoted.g.dart';

@riverpod
Future<List<LabReportResponse>> myLabReports(Ref ref) async {
  final repository = ref.watch(labReportsRepoProvider);

  final response = await repository.getMyLabReports();

  if (response.data == null) {
    throw ApiException(message: response.message);
  }

  return response.data!;
}

@riverpod
Future<LabReportResponse> labReportById(Ref ref, String id) async {
  final repository = ref.watch(labReportsRepoProvider);

  final response = await repository.getLabReportById(id);

  if (response.data == null) {
    throw ApiException(message: response.message);
  }

  return response.data!;
}

@riverpod
Future<List<LabReportResponse>> labReportsByAppointmentId(
  Ref ref,
  String appointmentId,
) async {
  final repository = ref.watch(labReportsRepoProvider);

  final response = await repository.getLabReportsByAppointmentId(appointmentId);

  if (response.data == null) {
    throw ApiException(message: response.message);
  }

  return response.data!;
}

@riverpod
class CreateLabReport extends _$CreateLabReport {
  @override
  FutureOr<LabReportResponse?> build() {
    return null;
  }

  Future<LabReportResponse> createLabReport(
    CreateLabReportRequest request,
  ) async {
    if (ref.mounted) state = const AsyncLoading();

    try {
      final repository = ref.read(labReportsRepoProvider);

      final response = await repository.createLabReport(request);

      if (response.data == null) {
        throw ApiException(
          message: response.message.isEmpty
              ? 'Could not upload the report'
              : response.message,
        );
      }

      if (ref.mounted) state = AsyncData(response.data!);

      return response.data!;
    } catch (e, stackTrace) {
      if (ref.mounted) state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}
