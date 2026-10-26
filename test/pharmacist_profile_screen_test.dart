import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/pharmacist/profile/presentation/pharmacist_profile_screen.dart';

void main() {
  testWidgets('Pharmacist profile screen matches the provided mockup', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: PharmacistProfileScreen()));

    expect(find.text('PS'), findsOneWidget);
    expect(find.text('Priya Shah'), findsOneWidget);
    expect(find.text('priya@citycare.in'), findsOneWidget);
    expect(find.text('Pharmacist'), findsOneWidget);
    expect(find.text('Professional details'), findsOneWidget);
    expect(find.text('License number'), findsOneWidget);
    expect(find.text('MH-PC-2018-04821'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
    expect(find.text('PharmaCare v2.4.0'), findsOneWidget);
  });
}
