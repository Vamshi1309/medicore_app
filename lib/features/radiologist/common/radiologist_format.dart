import 'package:flutter/material.dart';
import 'package:frontend/features/labReports/data/enums/report_types_enum.dart';
import 'package:intl/intl.dart';

const radiologistAvatarColors = [
  Color(0xFFE8DDF3),
  Color(0xFFDCE8FB),
  Color(0xFFF5E8BF),
  Color(0xFFDDF2E6),
  Color(0xFFFBE0DD),
];

String radiologistInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  final first = parts.first[0];
  final last = parts.length > 1 ? parts.last[0] : '';
  return (first + last).toUpperCase();
}

String radiologistRoleLabel(String? roleName) {
  if (roleName == null || roleName.isEmpty) return 'Radiologist';
  return roleName[0].toUpperCase() + roleName.substring(1);
}

String radiologistReportTypeLabel(String apiValue) {
  return ReportType.fromApi(apiValue)?.label ?? apiValue;
}

String formatRadiologistDate(DateTime date) {
  return DateFormat('MMM d, y').format(date.toLocal());
}

String formatRadiologistTime(DateTime date) {
  return DateFormat('h:mm a').format(date.toLocal());
}

String radiologistFileName(String reportUrl) {
  final trimmed = reportUrl.trim();
  if (trimmed.isEmpty) return 'Report file';
  final name = trimmed.split('/').last.split('?').first;
  return name.isEmpty ? 'Report file' : name;
}

bool radiologistFileIsPdf(String name) {
  return name.toLowerCase().endsWith('.pdf');
}

String radiologistDisplay(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return 'Not available';
  return trimmed;
}
