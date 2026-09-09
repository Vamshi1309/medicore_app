import 'package:flutter/material.dart';
import 'package:frontend/features/doctor/prescriptions/widgets/doctor_prescription_card.dart';
import 'package:frontend/features/doctor/widgets/doctor_header.dart';

class DoctorsAppointmentsScreen extends StatelessWidget {
  const DoctorsAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DoctorHeader(
              header: "Prescriptions",
              subHeader: "${prescriptions.length} total prescriptions written",
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: prescriptions.length,
                  itemBuilder: (context, index) {
                    final prescription = prescriptions[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: DoctorsPrescriptionCard(
                        patientName: prescription['patientName'],
                        reason: prescription['reason'],
                        date: prescription['date'],
                        medicineCount: prescription['medicineCount'],
                        onDownload: () {
                          // Download PDF
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> prescriptions = [
  {
    'patientName': 'Vamshi Dasari',
    'reason': 'Viral Fever',
    'date': 'Sep 04, 2026',
    'medicineCount': 3,
  },
  {
    'patientName': 'Rahul Reddy',
    'reason': 'Cold & Cough',
    'date': 'Sep 03, 2026',
    'medicineCount': 2,
  },
  {
    'patientName': 'Anjali Sharma',
    'reason': 'Migraine',
    'date': 'Sep 02, 2026',
    'medicineCount': 4,
  },
  {
    'patientName': 'Priya Singh',
    'reason': 'Stomach Infection',
    'date': 'Aug 30, 2026',
    'medicineCount': 3,
  },
  {
    'patientName': 'Kiran Kumar',
    'reason': 'Back Pain',
    'date': 'Aug 28, 2026',
    'medicineCount': 2,
  },
  {
    'patientName': 'Sneha Reddy',
    'reason': 'Allergy',
    'date': 'Aug 25, 2026',
    'medicineCount': 3,
  },
  {
    'patientName': 'Arjun Rao',
    'reason': 'Fever',
    'date': 'Aug 22, 2026',
    'medicineCount': 2,
  },
  {
    'patientName': 'Neha Patel',
    'reason': 'Throat Infection',
    'date': 'Aug 20, 2026',
    'medicineCount': 4,
  },
  {
    'patientName': 'Suresh Reddy',
    'reason': 'Blood Pressure',
    'date': 'Aug 18, 2026',
    'medicineCount': 3,
  },
];
