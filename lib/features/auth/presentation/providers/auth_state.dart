import 'package:frontend/features/auth/domain/entities/user.dart';

class AuthState {
  final bool isLoading;

  final bool isAuthenticated;

  final bool isInitialized;

  final User? user;

  final String? error;

  final String? message;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.user,
    this.message,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,

    bool? isAuthenticated,

    bool? isInitialized,

    User? user,

    String? message,

    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,

      isAuthenticated: isAuthenticated ?? this.isAuthenticated,

      isInitialized: isInitialized ?? this.isInitialized,

      user: user ?? this.user,

      message: message ?? this.message,

      error: error ?? this.error,
    );
  }
}
