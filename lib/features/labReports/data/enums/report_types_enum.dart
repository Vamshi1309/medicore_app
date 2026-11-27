enum ReportType {
  xray('XRAY', 'X-Ray'),
  mri('MRI', 'MRI'),
  ctScan('CT_SCAN', 'CT Scan'),
  bloodTest('BLOOD_TEST', 'Blood Test'),
  urineTest('URINE_TEST', 'Urine Test'),
  ultrasound('ULTRASOUND', 'Ultrasound');

  /// Must match the Java enum constant exactly (ReportType.valueOf is case-sensitive)
  final String apiValue;
  final String label;

  const ReportType(this.apiValue, this.label);

  static ReportType? fromApi(String? value) {
    for (final type in ReportType.values) {
      if (type.apiValue == value) return type;
    }
    return null;
  }
}