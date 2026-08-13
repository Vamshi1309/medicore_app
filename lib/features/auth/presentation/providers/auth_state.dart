import 'package:frontend/features/auth/domain/entities/user.dart';

class _Unset {
  const _Unset();
}

const _unset = _Unset();

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isInitialized;
  final User? user;
  final String? error;
  final String? message;
  final String? verificationId;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isInitialized = false,
    this.user,
    this.message,
    this.error,
    this.verificationId,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isInitialized,
    Object? user = _unset,
    Object? message = _unset,
    Object? error = _unset,
    Object? verificationId = _unset,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialized: isInitialized ?? this.isInitialized,
      user: user == _unset ? this.user : user as User?,
      message: message == _unset ? this.message : message as String?,
      error: error == _unset ? this.error : error as String?,
      verificationId: verificationId == _unset
          ? this.verificationId
          : verificationId as String?,
    );
  }
}
