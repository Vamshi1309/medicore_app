import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/screens/splash_screen.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:frontend/features/patient/widgets/patient_shell.dart';
import 'package:go_router/go_router.dart';

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
      ],
    );
  }
}
