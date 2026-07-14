import 'package:dio/dio.dart';


class ApiClient {

  final Dio dio;


  ApiClient(this.dio);



  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {

    return dio.get<T>(
      path,
      queryParameters: queryParameters,
    );
  }




  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
  }) {

    return dio.post<T>(
      path,
      data: data,
    );
  }




  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
  }) {

    return dio.put<T>(
      path,
      data: data,
    );
  }




  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
  }) {

    return dio.delete<T>(
      path,
      data: data,
    );
  }

}