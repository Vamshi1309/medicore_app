import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/radiologist/dashboard/radiologist_dashboard.dart';

void main() {
  testWidgets('radiologist dashboard shows greeting and summary cards', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RadiologistDashboard(),
      ),
    );

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Hello, Elena'), findsOneWidget);
    expect(find.text('08'), findsOneWidget);
    expect(find.text('Uploaded today'), findsOneWidget);
    expect(find.text('Upload new report'), findsOneWidget);
  });
}
