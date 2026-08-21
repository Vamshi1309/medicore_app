import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/storage/token_manager.dart';
import 'package:frontend/features/auth/data/models/request/patient_login_request.dart';
import 'package:frontend/features/auth/data/models/request/send_otp_request.dart';
import 'package:frontend/features/auth/data/models/request/staff_login_request.dart';
import 'package:frontend/features/auth/data/models/request/verify_login_otp.dart';
import 'package:frontend/features/auth/data/models/request/verify_register_otp.dart';
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

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return;
      }

      await TokenManager.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );

      await getMe();

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        message: response.message,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');
    }
  }

  Future<void> staffLogin(StaffLoginRequest req) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      final response = await repository.staffLogin(req);

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return;
      }

      await TokenManager.saveTokens(
        accessToken: response.data!.accessToken,
        refreshToken: response.data!.refreshToken,
      );

      await getMe();

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        message: response.message,
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      await repository.logout();

      await TokenManager.clearTokens();

      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        user: null,
        message: 'Logged out successfully',
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');
    }
  }

  Future<void> checkAuthentication() async {
    final accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      state = state.copyWith(isAuthenticated: false, isInitialized: true);
      return;
    }

    try {
      await getMe();

      state = state.copyWith(isInitialized: true);
    } on ApiException {
      await TokenManager.clearTokens();

      state = state.copyWith(isAuthenticated: false, isInitialized: true);
    } catch (e) {
      await TokenManager.clearTokens();

      state = state.copyWith(isAuthenticated: false, isInitialized: true);
    }
  }

  Future<bool> sendRegisterOtpRequest(String phoneNumber) async {
    try {
      state = state.copyWith(isLoading: true, error: null, message: null);

      final response = await repository.sendRegistrationOtp(
        SendOtpRequest(phoneNumber: phoneNumber),
      );

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return false;
      }

      state = state.copyWith(isLoading: false, message: response.message);

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);

      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');

      return false;
    }
  }

  Future<bool> verifyRegistrationOtp(
    VerifyRegistrationOtpRequest request,
  ) async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    try {
      final response = await repository.verifyRegistrationOtp(request);

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return false;
      }

      state = state.copyWith(isLoading: false, message: response.message);

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);

      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');

      return false;
    }
  }

  Future<bool> sendLoginOtp(String phoneNumber) async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    try {
      final response = await repository.sendLoginOtp(
        SendOtpRequest(phoneNumber: phoneNumber),
      );

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return false;
      }

      state = state.copyWith(isLoading: false, message: response.message);

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);

      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');

      return false;
    }
  }

  Future<bool> verifyLoginOtp(VerifyLoginOtpRequest request) async {
    state = state.copyWith(isLoading: true, error: null, message: null);

    try {
      final response = await repository.verifyLoginOtp(request);

      if (!response.success || response.data == null) {
        state = state.copyWith(isLoading: false, error: response.message);
        return false;
      }

      final loginData = response.data!;

      await TokenManager.saveTokens(
        accessToken: loginData.accessToken,
        refreshToken: loginData.refreshToken,
      );

      await getMe();

      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        message: response.message,
      );

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);

      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');

      return false;
    }
  }

  Future<void> getMe() async {
    final response = await repository.getMe();

    if (!response.success || response.data == null) {
      throw ApiException(message: response.message);
    }

    final user = response.data!.toEntity();

    state = state.copyWith(isAuthenticated: true, user: user);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
