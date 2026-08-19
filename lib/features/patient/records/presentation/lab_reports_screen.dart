import 'package:flutter/material.dart';
import 'package:frontend/features/patient/records/widgets/record_lab_report_card.dart';

class LabReportsScreen extends StatelessWidget {
  const LabReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final labReports = [
      {
        'reportName': 'X-Ray',
        'doctorName': 'Dr. Laxmi Dasari',
        'date': 'Dec 15, 2024',
        'notes': 'No significant abnormality detected.',
      },
      {
        'reportName': 'MRI Brain',
        'doctorName': 'Dr. Arjun Mehta',
        'date': 'Nov 28, 2024',
        'notes': 'MRI findings are within normal limits.',
      },
      {
        'reportName': 'Blood Test',
        'doctorName': 'Dr. Priya Sharma',
        'date': 'Nov 10, 2024',
        'notes': 'Blood parameters are within the normal range.',
      },
    ];
    return ListView(
      padding: const EdgeInsets.only(top: 12),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '3 reports available',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6F7785),
            ),
          ),
        ),

        const SizedBox(height: 8),

        for (final item in labReports)
          RecordlabReportCard(
            reportName: item['reportName'] as String,
            doctorName: item['doctorName'] as String,
            date: item['date'] as String,
            notes: item['notes'] as String,
            onDownload: () {},
          ),
      ],
    );
  }
}
