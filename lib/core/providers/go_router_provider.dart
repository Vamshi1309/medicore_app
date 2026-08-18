import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_router.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/auth/presentation/providers/auth_state.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final controller = StreamController<AuthState>.broadcast();

  ref.listen<AuthState>(authProvider, (previous, next) {
    debugPrint(
      'AUTH CHANGED -> '
      'initialized: ${next.isInitialized}, '
      'authenticated: ${next.isAuthenticated}, '
      'user: ${next.user?.name}',
    );

    controller.add(next);
  });

  final refreshListenable = GoRouterRefreshStream(controller.stream);

  ref.onDispose(() {
    refreshListenable.dispose();
    controller.close();
  });

  return AppRouter.create(ref: ref, refreshListenable: refreshListenable);
});

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
