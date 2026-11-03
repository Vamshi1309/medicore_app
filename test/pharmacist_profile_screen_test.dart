import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend/features/pharmacist/data/models/pharmacist_profile_response.dart';
import 'package:frontend/features/pharmacist/data/providers/pharmacist_profile_provider.dart';
import 'package:frontend/features/pharmacist/profile/presentation/pharmacist_profile_screen.dart';
import 'package:frontend/shared/enums/user_role.dart';

class TestAuthNotifier extends AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(
      user: User(
        id: 'user-1',
        name: 'Test Pharmacist',
        phoneNumber: '+919876543210',
        role: UserRole.pharmacist,
      ),
    );
  }
}

class TestPharmacistProfileNotifier extends PharmacistProfileNotifier {
  @override
  Future<PharmacistProfileResponse> build() async {
    return PharmacistProfileResponse(
      userId: 'user-1',
      name: 'Test Pharmacist',
      email: 'test.pharmacist@citycare.in',
      phoneNumber: '+919900112233',
      licenseNumber: 'PH-2025-7788',
    );
  }
}

void main() {
  testWidgets('Pharmacist profile screen uses auth and pharmacist profile data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith(() => TestAuthNotifier()),
          pharmacistProfileProvider.overrideWith(
            () => TestPharmacistProfileNotifier(),
          ),
        ],
        child: const MaterialApp(home: PharmacistProfileScreen()),
      ),
    );

    await tester.pump();

    expect(find.text('Test Pharmacist'), findsOneWidget);
    expect(find.text('test.pharmacist@citycare.in'), findsNWidgets(2));
    expect(find.text('PH-2025-7788'), findsOneWidget);
    expect(find.text('+919900112233'), findsOneWidget);
    expect(find.text('Pharmacist'), findsOneWidget);
    expect(find.text('Professional details'), findsOneWidget);
    expect(find.text('License number'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);
  });
}
