import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/network/connectivity_service.dart';

class ConnectivityInterceptor extends Interceptor {
  final ConnectivityService connectivityService;

  ConnectivityInterceptor({required this.connectivityService});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await connectivityService.isConnected;

    if (!isConnected) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: ApiException(message: "No Internet Connection"),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    handler.next(options);
  }
}
