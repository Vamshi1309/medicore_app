import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("========================== Request ==========================");

    debugPrint("Method: ${options.method}");

    debugPrint("URL: ${options.uri}");

    debugPrint("HEADERS:");
    debugPrint(options.headers.toString());

    debugPrint("BODY:");
    debugPrint(options.data);

    debugPrint(
      "================================= End ========================",
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint("======================== RESPONSE =======================");

    debugPrint("STATUS: ${response.statusCode}");

    debugPrint("URL: ${response.requestOptions.uri}");

    debugPrint("BODY:");
    debugPrint(response.data);

    debugPrint("========================= End =======================");

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint("====================== ERROR ===========================");

    debugPrint("URL: ${err.requestOptions.uri}");

    debugPrint("STATUS: ${err.response?.statusCode}");

    debugPrint("MESSAGE: ${err.message}");

    debugPrint("RESPONSE:");
    debugPrint(err.response?.data);

    debugPrint("======================== End =========================");

    handler.next(err);
  }
}
