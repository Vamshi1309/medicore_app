import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/storage/token_manager.dart';

class RefreshInterceptor extends QueuedInterceptor {
  final Dio dio;

  bool isRefreshing = false;

  RefreshInterceptor({required this.dio});

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    if (err.requestOptions.path == ApiConstants.refreshToken) {
      return handler.next(err);
    }

    try {
      final refreshToken = await TokenManager.getRefreshToken();

      if (refreshToken == null) {
        return handler.next(err);
      }

      final newAccessToken = await _refreshToken(refreshToken);

      if (newAccessToken == null) {
        return handler.next(err);
      }

      // retry old request

      final requestOptions = err.requestOptions;

      requestOptions.headers["Authorization"] = "Bearer $newAccessToken";

      final response = await dio.fetch(requestOptions);

      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  Future<String?> _refreshToken(String refreshToken) async {
    final response = await dio.post(
      ApiConstants.refreshToken,
      data: {"refreshToken": refreshToken},
      options: Options(extra: {"skipAuth": true, "skipRefresh": true}),
    );

    final data = response.data["data"];

    if (data == null) {
      return null;
    }

    final accessToken = data["accessToken"];
    final newRefreshToken = data["refreshToken"];

    if (accessToken == null || newRefreshToken == null) {
      return null;
    }

    await TokenManager.saveTokens(
      accessToken: accessToken,
      refreshToken: newRefreshToken,
    );

    return accessToken;
  }
}
