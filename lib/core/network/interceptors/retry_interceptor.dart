import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:frontend/core/storage/token_manager.dart';

class RefreshInterceptor extends QueuedInterceptor {
  RefreshInterceptor({
    required this.dio,
    required this.refreshDio,
    required this.onSessionExpired,
  });

  final Dio dio; // main dio, for retry
  final Dio refreshDio; // plain Dio, no interceptors
  final VoidCallback onSessionExpired; // sets AuthState.unauthenticated

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final opts = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        opts.path == ApiConstants.refreshToken ||
        AuthInterceptor.publicAuthRoutes.contains(opts.path) ||
        opts.extra['skipAuth'] == true ||
        opts.extra['retried'] == true) {
      return handler.next(err);
    }

    // Already refreshed by a previous queued request?
    final current = await TokenManager.getAccessToken();
    if (current != null && opts.headers['Authorization'] != 'Bearer $current') {
      return _retry(opts, current, handler, err);
    }

    final refreshToken = await TokenManager.getRefreshToken();
    if (refreshToken == null) {
      await TokenManager.clearTokens();
      onSessionExpired();
      return handler.next(err);
    }

    try {
      final res = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = res.data['data'];
      final access = data?['accessToken'];
      final refresh = data?['refreshToken'];
      if (access == null || refresh == null)
        throw StateError('bad refresh response');

      await TokenManager.saveTokens(accessToken: access, refreshToken: refresh);
      return _retry(opts, access, handler, err);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 400 || code == 401 || code == 403) {
        await TokenManager.clearTokens();
        onSessionExpired();
      }
      // network error or 5xx: keep the session
      return handler.next(err);
    } catch (_) {
      return handler.next(err);
    }
  }

  Future<void> _retry(
    RequestOptions opts,
    String token,
    ErrorInterceptorHandler handler,
    DioException original,
  ) async {
    opts.extra['retried'] = true;
    opts.headers['Authorization'] = 'Bearer $token';
    try {
      handler.resolve(await refreshDio.fetch(opts)); // refreshDio, not dio
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
