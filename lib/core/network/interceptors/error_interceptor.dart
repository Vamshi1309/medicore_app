import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiException exception;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        exception = ApiException(
          message: "Connection timeout. Please try again.",
        );

        break;

      case DioExceptionType.connectionError:
        exception = ApiException(message: "No internet connection.");

        break;

      case DioExceptionType.badResponse:
        exception = _handleStatusCode(err.response);

        break;

      default:
        exception = ApiException(message: "Something went wrong.");
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  ApiException _handleStatusCode(Response? response) {
    switch (response?.statusCode) {
      case 400:
        return ApiException(message: "Invalid request", statusCode: 400);

      case 401:
        return ApiException(message: "Unauthorized", statusCode: 401);

      case 403:
        return ApiException(message: "Access denied", statusCode: 403);

      case 404:
        return ApiException(message: "Data not found", statusCode: 404);

      case 500:
        return ApiException(message: "Server error", statusCode: 500);

      default:
        return ApiException(
          message: "Unexpected error",
          statusCode: response?.statusCode,
        );
    }
  }
}
