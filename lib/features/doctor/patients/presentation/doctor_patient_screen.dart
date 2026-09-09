import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/features/doctor/patients/widgets/doctors_patient_row_card.dart';
import 'package:frontend/features/doctor/widgets/doctor_header.dart';

class DoctorPatientScreen extends StatelessWidget {
  const DoctorPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DoctorHeader(
              header: "My Patients",
              subHeader: "${patients.length} Patients registered",
              child: AppSearchBar(hintText: "Type patient name.."),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];

                    return DoctorsPatientRowCard(
                      patinetName: patient['patientName'],
                      lastVisited: patient['lastVisited'],
                      totalVisits: patient['totalVisits'],
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

final List<Map<String, dynamic>> patients = [
  {
    'patientName': 'Vamshi Dasari',
    'lastVisited': DateTime(2026, 9, 5),
    'totalVisits': 8,
  },
  {
    'patientName': 'Rahul Reddy',
    'lastVisited': DateTime(2026, 8, 28),
    'totalVisits': 5,
  },
  {
    'patientName': 'Anjali Sharma',
    'lastVisited': DateTime(2026, 9, 2),
    'totalVisits': 12,
  },
  {
    'patientName': 'Priya Singh',
    'lastVisited': DateTime(2026, 8, 20),
    'totalVisits': 4,
  },
  {
    'patientName': 'Kiran Kumar',
    'lastVisited': DateTime(2026, 9, 1),
    'totalVisits': 7,
  },
  {
    'patientName': 'Sneha Reddy',
    'lastVisited': DateTime(2026, 7, 15),
    'totalVisits': 15,
  },
  {
    'patientName': 'Arjun Rao',
    'lastVisited': DateTime(2026, 8, 10),
    'totalVisits': 3,
  },
  {
    'patientName': 'Neha Patel',
    'lastVisited': DateTime(2026, 9, 7),
    'totalVisits': 9,
  },
];
