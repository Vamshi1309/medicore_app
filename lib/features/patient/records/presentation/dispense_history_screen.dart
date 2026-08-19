import 'package:flutter/material.dart';
import 'package:frontend/features/patient/records/widgets/record_dispense_history_card.dart';

class DispenseHistoryScreen extends StatelessWidget {
  const DispenseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final medicines = [
      {
        'medicineName': 'Paracetamol 500mg',
        'price': 120.0,
        'tabletCount': 10,
        'pharmacistName': 'Ravi Kumar',
        'date': 'Dec 15, 2024',
      },
      {
        'medicineName': 'Azithromycin 250mg',
        'price': 85.0,
        'tabletCount': 6,
        'pharmacistName': 'Suresh Pharmacy',
        'date': 'Nov 28, 2024',
      },
      {
        'medicineName': 'Cetirizine 10mg',
        'price': 65.0,
        'tabletCount': 10,
        'pharmacistName': 'Anil Kumar',
        'date': 'Nov 20, 2024',
      },
      {
        'medicineName': 'Amoxicillin 500mg',
        'price': 150.0,
        'tabletCount': 14,
        'pharmacistName': 'Ravi Kumar',
        'date': 'Nov 12, 2024',
      },
      {
        'medicineName': 'Pantoprazole 40mg',
        'price': 95.0,
        'tabletCount': 10,
        'pharmacistName': 'Priya Medicals',
        'date': 'Nov 05, 2024',
      },
    ];

    return ListView(
      padding: const EdgeInsets.only(top: 12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${medicines.length} medicines dispensed',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6F7785),
            ),
          ),
        ),

        const SizedBox(height: 8),

        for (final item in medicines)
          RecordDispenseHistoryCard(
            medicineName: item['medicineName'] as String,
            price: item['price'] as double,
            tabletCount: item['tabletCount'] as int,
            pharmacistName: item['pharmacistName'] as String,
            date: item['date'] as String,
          ),
      ],
    );
  }
}