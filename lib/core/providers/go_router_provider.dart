import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  return AppRouter.create(authState: authState);
});
