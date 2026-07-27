import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/token_manager.dart';
import 'package:frontend/features/auth/data/models/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/staff_login_request.dart';
import 'package:frontend/features/auth/data/repositories/auth_respository.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend/features/auth/providers/auth_repository_provider.dart';

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository repository;

  @override
  AuthState build() {
    repository = ref.read(authRepositoryProvider);
    return const AuthState();
  }

  Future<void> patientLogin(PatientLoginRequest req) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      final response = await repository.patientLogin(req);

      if (!response.success) {
        state = state.copyWith(isLoading: false, error: response.message);
        return;
      }

      TokenManager.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: response.data!.user,
        message: response.message,
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Something went wrong";

      state = state.copyWith(isLoading: false, error: message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> staffLogin(StaffLoginRequest req) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      final response = await repository.staffLogin(req);

      if (!response.success) {
        state = state.copyWith(isLoading: false, error: response.message);
        return;
      }

      TokenManager.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );

      state = state.copyWith(
        isLoading: false,

        isAuthenticated: true,

        user: response.data!.user,

        message: response.message,
      );
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? "Something went wrong";

      state = state.copyWith(isLoading: false, error: message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken != null) {
      state = state.copyWith(isAuthenticated: true, isInitialized: true);
    } else {
      state = state.copyWith(isAuthenticated: false, isInitialized: true);
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
