import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend/features/labReports/data/models/lab_report_response.dart';
import 'package:frontend/features/labReports/providers/lab_reports_provider_annoted.dart';
import 'package:frontend/features/radiologist/dashboard/radiologist_dashboard.dart';
import 'package:frontend/shared/enums/user_role.dart';

void main() {
  testWidgets('radiologist dashboard shows the signed-in radiologist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(_TestAuthNotifier.new),
          myLabReportsProvider.overrideWith(
            (ref) async => [
              LabReportResponse(
                reportId: 'r1',
                appointmentId: 'a1',
                patientId: 'p1',
                patientName: 'Maya Thompson',
                radiologistId: 'rad',
                radiologistName: 'Elena',
                reportType: 'MRI',
                reportUrl: 'reports/maya.pdf',
                findings: 'Mild disc bulge',
                createdAt: DateTime.now(),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: RadiologistDashboard()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Good morning'), findsOneWidget);
    expect(find.text('Elena'), findsOneWidget);
    expect(find.text('Radiologist'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.text('Uploaded today'), findsOneWidget);
    expect(find.text('Maya Thompson'), findsOneWidget);
    expect(find.text('Upload new report'), findsOneWidget);
  });
}

class _TestAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(
      isAuthenticated: true,
      isInitialized: true,
      user: User(
        id: '1',
        name: 'Elena',
        staffId: 'RAD-0001',
        role: UserRole.radiologist,
      ),
    );
  }
}
