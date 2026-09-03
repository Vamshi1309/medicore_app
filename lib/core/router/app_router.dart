import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/screens/splash_screen.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/select_doctor_step.dart';
import 'package:frontend/features/patient/profile/presentation/edit_profile_screen.dart';
import 'package:frontend/features/patient/widgets/patient_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/booking_shell.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/select_doctor_step.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/select_date_step.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/select_time_step.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/notes_step.dart';
import 'package:frontend/features/patient/dashboard/presentation/screens/booking/confirm_step.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create({
    required Ref ref,
    required Listenable refreshListenable,
  }) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: refreshListenable,
      redirect: (context, state) {
        final authState = ref.read(authProvider);
        final location = state.matchedLocation;

        const publicRoutes = {AppRoutes.login, AppRoutes.register};

        if (!authState.isInitialized) {
          return location == AppRoutes.splash ? null : AppRoutes.splash;
        }

        if (!authState.isAuthenticated) {
          return publicRoutes.contains(location) ? null : AppRoutes.login;
        }

        // Authenticated user — keep them off splash/login/register
        final authRoutes = {AppRoutes.splash, ...publicRoutes};
        if (authRoutes.contains(location)) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const PatientShell(initialIndex: 0),
        ),
        GoRoute(
          path: AppRoutes.patientAppointment,
          builder: (context, state) => const PatientShell(initialIndex: 1),
        ),
        GoRoute(
          path: AppRoutes.patientRecord,
          builder: (context, state) => const PatientShell(initialIndex: 2),
        ),
        GoRoute(
          path: AppRoutes.patientProfile,
          builder: (context, state) => const PatientShell(initialIndex: 3),
        ),
        GoRoute(
          path: AppRoutes.editPatientProfile,
          builder: ((context, state) => const EditProfileScreen()),
        ),
        ShellRoute(
          builder: (context, state, child) {
            final step = _stepIndexForLocation(state.uri.path);
            return BookingShell(currentStep: step, child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.bookAppointment,
              builder: (_, _) => const SelectDoctorStep(),
            ),
            GoRoute(
              path: AppRoutes.bookAppointmentDate,
              builder: (_, _) => const SelectDateStep(),
            ),
            GoRoute(
              path: AppRoutes.bookAppointmentTime,
              builder: (_, _) => const SelectTimeStep(),
            ),
            GoRoute(
              path: AppRoutes.bookAppointmentNotes,
              builder: (_, _) => const NotesStep(),
            ),
            GoRoute(
              path: AppRoutes.bookAppointmentConfirm,
              builder: (_, _) => const ConfirmStep(),
            ),
          ],
        ),
      ],
    );
  }

  static int _stepIndexForLocation(String location) {
    const order = ["", "/date", "/time", "/notes", "/confirm"];

    for (var i = 0; i < order.length; i++) {
      if (location.endsWith(order[i]) && order[i].isNotEmpty) return i;
    }
    return 0;
  }
}
