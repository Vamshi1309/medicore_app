class ApiResponse<T> {

  final bool success;
  final String message;
  final T? data;


  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });



  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJson,
  ) {

    return ApiResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? fromJson(json['data'])
          : null,
    );

  }

}