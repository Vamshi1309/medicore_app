class LabReportResponse {
  final String reportId;
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String radiologistId;
  final String radiologistName;
  final String reportType;
  final String reportUrl;
  final String findings;
  final DateTime createdAt;

  const LabReportResponse({
    required this.reportId,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.radiologistId,
    required this.radiologistName,
    required this.reportType,
    required this.reportUrl,
    required this.findings,
    required this.createdAt,
  });

  factory LabReportResponse.fromJson(Map<String, dynamic> json) {
    return LabReportResponse(
      reportId: json['reportId'] as String,
      appointmentId: json['appointmentId'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      radiologistId: json['radiologistId'] as String,
      radiologistName: json['radiologistName'] as String,
      reportType: json['reportType'] as String,
      reportUrl: json['reportUrl'] as String,
      findings: json['findings'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'appointmentId': appointmentId,
      'patientId': patientId,
      'patientName': patientName,
      'radiologistId': radiologistId,
      'radiologistName': radiologistName,
      'reportType': reportType,
      'reportUrl': reportUrl,
      'findings': findings,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  LabReportResponse copyWith({
    String? reportId,
    String? appointmentId,
    String? patientId,
    String? patientName,
    String? radiologistId,
    String? radiologistName,
    String? reportType,
    String? reportUrl,
    String? findings,
    DateTime? createdAt,
  }) {
    return LabReportResponse(
      reportId: reportId ?? this.reportId,
      appointmentId: appointmentId ?? this.appointmentId,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      radiologistId: radiologistId ?? this.radiologistId,
      radiologistName: radiologistName ?? this.radiologistName,
      reportType: reportType ?? this.reportType,
      reportUrl: reportUrl ?? this.reportUrl,
      findings: findings ?? this.findings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}