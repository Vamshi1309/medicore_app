import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_client.dart';
import 'package:frontend/core/network/dio_client.dart';

final dioProvider = Provider((ref) {
  return DioClient.dio;
});

final apiClientProvider = Provider((ref) {
  final dio = ref.watch(dioProvider);

  return ApiClient(dio);
});
