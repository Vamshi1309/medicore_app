import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/patient/appointments/presentation/appointment_screen.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/providers/appointment_provider.dart';

class FakePatientAppointmentsNotifier
    extends PatientAppointmentNotifier {
  @override
  Future<List<AppointmentResponse>> build() async {
    return [
      AppointmentResponse(
        appointmentId: '1',
        patientId: 'patient-1',
        patientName: 'John Doe',
        doctorId: 'doctor-1',
        doctorName: 'Dr. Smith',
        doctorSpecialization: 'Cardiology',
        createdById: 'admin-1',
        createdByName: 'Admin',
        scheduledAt: DateTime(2026, 8, 30, 10, 30),
        status: AppointmentStatus.confirmed,
        notes: 'Checkup',
        createdAt: DateTime(2026, 8, 20),
      ),
    ];
  }
}

void main() {
  testWidgets('shows centered empty state when selected filter has no items', (
    WidgetTester tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 2000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          patientAppointmentsProvider.overrideWith(
            () => FakePatientAppointmentsNotifier(),
          ),
        ],
        child: const MaterialApp(home: AppointmentScreen()),
      ),
    );

    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();

    expect(find.text('No Previous Appointments'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Center && widget.child is EmptyState,
      ),
      findsOneWidget,
    );
  });
}
