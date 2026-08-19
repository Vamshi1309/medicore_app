import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/patient/records/widgets/record_prescription_card.dart';

void main() {
  testWidgets('Prescription record card renders doctor info and PDF action', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RecordPrescriptionCard(
            doctorName: 'Dr. Laxmi Dasari',
            specialty: 'Dermatology',
            date: 'Dec 15, 2024',
            medicineCount: 3,
            onDownload: null,
          ),
        ),
      ),
    );

    expect(find.text('Dr. Laxmi Dasari'), findsOneWidget);
    expect(find.text('Dermatology'), findsOneWidget);
    expect(find.text('3 medicines prescribed'), findsOneWidget);
    expect(find.text('PDF'), findsOneWidget);
  });
}
