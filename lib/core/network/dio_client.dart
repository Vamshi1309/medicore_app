import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_constants.dart';
import 'package:frontend/core/network/connectivity_service.dart';
import 'package:frontend/core/network/interceptors/auth_interceptor.dart';
import 'package:frontend/core/network/interceptors/connectivity_interceptor.dart';
import 'package:frontend/core/network/interceptors/error_interceptor.dart';
import 'package:frontend/core/network/interceptors/logger_interceptor.dart';
import 'package:frontend/core/network/interceptors/retry_interceptor.dart';

class DioClient {
  DioClient._();

  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,

        connectTimeout: const Duration(seconds: 10),

        validateStatus: (status) {
          return status != null && status >= 200 && status < 300;
        },

        receiveTimeout: const Duration(seconds: 10),

        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      ConnectivityInterceptor(connectivityService: ConnectivityService()),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggerInterceptor(),
      RefreshInterceptor(dio: dio),
      ErrorInterceptor(),
    ]);

    return dio;
  }
}
