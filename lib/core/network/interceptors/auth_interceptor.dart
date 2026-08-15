import 'package:dio/dio.dart';
import 'package:frontend/core/storage/token_manager.dart';

class AuthInterceptor extends Interceptor {
  static const publicAuthRoutes = {
    '/api/auth/login',
    '/api/auth/staff/login',
    '/api/auth/register',
    '/api/auth/refresh',
    '/api/auth/register/send-otp',
    '/api/auth/login/send-otp',
    '/api/auth/register/verify-otp',
    '/api/auth/login/verify-otp',

  };

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (publicAuthRoutes.contains(options.path)) {
      handler.next(options);
      return;
    }

    final token = await TokenManager.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
