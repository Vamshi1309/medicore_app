import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/shared/enums/user_role.dart';

class AuthGuard {
  AuthGuard._();

  static String? roleGuard({
    required BuildContext context,
    required Ref ref,
    required List<UserRole> allowedRoles,
    required String redirectRoute,
  }) {
    final authState = ref.read(authProvider);
    final user = authState.user;

    if (!authState.isAuthenticated || user == null) {
      return AppRoutes.login;
    }

    if (!allowedRoles.contains(user.role)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          AppSnackBar.error(context, "You don't have permission");
        }
      });

      return redirectRoute;
    }

    return null;
  }
}
