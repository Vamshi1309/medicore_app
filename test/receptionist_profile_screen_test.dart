import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/receptionist/profile/presentation/screens/receptionist_profile_screen.dart';

void main() {
  testWidgets('Receptionist profile screen renders the provided profile data', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReceptionistProfileScreen(),
      ),
    );

    expect(find.text('Maya Thornton'), findsWidgets);
    expect(find.text('maya.thorton@clinic.com'), findsWidgets);
    expect(find.text('Personal Information'), findsOneWidget);
    expect(find.text('Shift Information'), findsOneWidget);
    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);
  });
}
