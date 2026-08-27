import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final bool isTextBold;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color color;
  final bool outlined;

  const PrimaryButton({
    super.key,
    required this.text,
    this.isTextBold = true,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.color = AppColors.primary,
    this.prefixIcon,
    this.suffixIcon,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Icon(
                  prefixIcon,
                  fontWeight: isTextBold ? FontWeight.bold : null,
                  size: 16,
                ),
                const SizedBox(width: AppSizes.sm),
              ],
              Text(
                text,
                style: TextStyle(
                  fontWeight: isTextBold ? FontWeight.bold : null,
                  fontSize: 18
                ),
              ),
              if (suffixIcon != null) ...[
                const SizedBox(width: AppSizes.sm),
                Icon(
                  suffixIcon,
                  fontWeight: isTextBold ? FontWeight.bold : null,
                  size: 16,
                ),
              ],
            ],
          );

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: enabled && !isLoading ? onPressed : null,
          style: OutlinedButton.styleFrom(backgroundColor: color),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(backgroundColor: color),
        child: child,
      ),
    );
  }
}
