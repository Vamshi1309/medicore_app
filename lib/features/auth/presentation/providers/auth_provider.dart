import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/storage/token_manager.dart';
import 'package:frontend/features/auth/data/firebase_auth_service.dart';
import 'package:frontend/features/auth/data/models/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/staff_login_request.dart';
import 'package:frontend/features/auth/data/repositories/auth_respository.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend/features/auth/providers/auth_repository_provider.dart';

class AuthNotifier extends Notifier<AuthState> {
  late AuthRepository repository;
  late FirebaseAuthService firebaseAuthService;

  @override
  AuthState build() {
    repository = ref.read(authRepositoryProvider);
    firebaseAuthService = FirebaseAuthService();

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

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      await repository.logout();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        message: "Logged out successfully",
      );

      await TokenManager.clearTokens();
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

  Future<void> sendFirebaseOtp(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      final verificationId = await firebaseAuthService.sendOtp(
        phoneNumber: phoneNumber,
      );

      state = state.copyWith(
        isLoading: false,
        verificationId: verificationId,
        message: "OTP sent successfully",
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> verifyFirebaseOtp(String otp) async {
    try {
      if (state.verificationId == null) {
        state = state.copyWith(
          error: "OTP session expired. Please request a new OTP.",
        );
        return false;
      }

      state = state.copyWith(isLoading: true, error: null, message: null);

      await firebaseAuthService.verifyOtp(
        verificationId: state.verificationId!,
        otp: otp,
      );

      state = state.copyWith(
        isLoading: false,
        message: "OTP verified successfully",
      );

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());

      return false;
    }
  }

  Future<String?> getFirebaseIdToken() async {
    try {
      return await firebaseAuthService.getIdToken();
    } catch (e) {
      state = state.copyWith(error: e.toString());

      return null;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
