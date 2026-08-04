import 'package:flutter/material.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void show({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);

    // Clear any existing snackbars
    messenger.clearSnackBars();

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void success(
    BuildContext context,
    String message,
  ) {
    show(
      context: context,
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: Colors.green,
    );
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    show(
      context: context,
      message: message,
      icon: Icons.error_rounded,
      backgroundColor: Colors.red,
    );
  }

  static void warning(
    BuildContext context,
    String message,
  ) {
    show(
      context: context,
      message: message,
      icon: Icons.warning_amber_rounded,
      backgroundColor: Colors.orange,
    );
  }

  static void info(
    BuildContext context,
    String message,
  ) {
    show(
      context: context,
      message: message,
      icon: Icons.info_rounded,
      backgroundColor: Colors.blue,
    );
  }
}