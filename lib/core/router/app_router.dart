import 'package:flutter/material.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/screens/splash_screen.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend/features/auth/presentation/screens/login_screen.dart';
import 'package:frontend/features/auth/presentation/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static GoRouter create({required AuthState authState}) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final location = state.matchedLocation;

        if (!authState.isInitialized) {
          return location == AppRoutes.splash ? null : AppRoutes.splash;
        }

        if (!authState.isAuthenticated) {
          const publicRoutes = {AppRoutes.login, AppRoutes.register};

          return publicRoutes.contains(location) ? null : AppRoutes.login;
        }

        return location == AppRoutes.home ? null : AppRoutes.home;
      },

      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: ((context, state) {
            return const LoginScreen();
          }),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: ((context, state) {
            return const RegisterScreen();
          }),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: ((context, state) {
            return const Scaffold(body: Center(child: Text("Home Screen")));
          }),
        ),
      ],
    );
  }
}
