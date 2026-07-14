import 'package:dio/dio.dart';
import 'package:frontend/core/storage/token_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await TokenManager.getAccessToken();

    if(token != null && token.isNotEmpty){
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
