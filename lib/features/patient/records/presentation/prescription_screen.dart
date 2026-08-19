import 'package:flutter/material.dart';
import 'package:frontend/features/patient/records/widgets/record_prescription_card.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescriptions = [
      {
        'doctorName': 'Dr. Laxmi Dasari',
        'specialty': 'Dermatology',
        'date': 'Dec 15, 2024',
        'medicineCount': 3,
      },
      {
        'doctorName': 'Dr. Arjun Mehta',
        'specialty': 'General Medicine',
        'date': 'Nov 28, 2024',
        'medicineCount': 5,
      },
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 12),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '2 prescriptions available',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6F7785),
            ),
          ),
        ),

        const SizedBox(height: 8),

        for (final item in prescriptions)
          RecordPrescriptionCard(
            doctorName: item['doctorName'] as String,
            specialty: item['specialty'] as String,
            date: item['date'] as String,
            medicineCount: item['medicineCount'] as int,
            onDownload: () {},
          ),
      ],
    );
  }
}
