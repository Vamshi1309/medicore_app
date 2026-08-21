import 'package:dio/dio.dart';
import 'package:frontend/core/network/api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
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
        exception = ApiException(
          message: "No internet connection.",
        );
        break;

      case DioExceptionType.badResponse:
        exception = _handleStatusCode(err.response);
        break;

      default:
        exception = ApiException(
          message: "Something went wrong.",
        );
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
    final statusCode = response?.statusCode;

    final message = response?.data is Map<String, dynamic>
        ? response?.data['message']?.toString()
        : null;

    return ApiException(
      message: message ?? _defaultMessage(statusCode),
      statusCode: statusCode,
    );
  }

  String _defaultMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Invalid request";

      case 401:
        return "Unauthorized";

      case 403:
        return "Access denied";

      case 404:
        return "Data not found";

      case 500:
        return "Server error";

      default:
        return "Unexpected error";
    }
  }
}