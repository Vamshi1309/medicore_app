import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final IconData? icon;

  final String title;
  final String message;

  final String confirmText;
  final String? cancelText;

  final Color? confirmColor;

  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  static Future<T?> show<T>(
    BuildContext context, {
    IconData? icon,
    required String title,
    required String message,
    required String confirmText,
    String? cancelText,
    Color? confirmColor,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => ConfirmationDialog(
        icon: icon,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.icon,
    required this.message,
    required this.confirmText,
    this.cancelText,
    this.confirmColor,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: icon != null
          ? Icon(
              icon,
              color: confirmColor ?? Theme.of(context).colorScheme.primary,
            )
          : null,
      title: Text(title),
      content: Text(message),
      actions: [
        if (onCancel != null) ...[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onCancel?.call();
            },
            child: Text(
              cancelText ?? "Cancel",
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
