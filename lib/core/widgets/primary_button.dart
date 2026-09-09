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

  // Internal button type
  final _ButtonType _type;

  // Primary
  const PrimaryButton.primary({
    super.key,
    required this.text,
    required this.onPressed,
    this.isTextBold = true,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.color = AppColors.primary,
  }) : _type = _ButtonType.primary;

  // Outlined
  const PrimaryButton.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.isTextBold = true,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.color = AppColors.primary,
  }) : _type = _ButtonType.outlined;

  // Outlined + filled
  const PrimaryButton.outlinedFilled({
    super.key,
    required this.text,
    required this.onPressed,
    this.isTextBold = true,
    this.isLoading = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.color = AppColors.primary,
  }) : _type = _ButtonType.outlinedFilled;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: _type == _ButtonType.primary ? Colors.white : color,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 16),
                const SizedBox(width: AppSizes.sm),
              ],

              Text(
                text,
                style: TextStyle(
                  fontWeight: isTextBold ? FontWeight.bold : null,
                  fontSize: 18,
                ),
              ),

              if (suffixIcon != null) ...[
                const SizedBox(width: AppSizes.sm),
                Icon(suffixIcon, size: 16),
              ],
            ],
          );

    if (_type == _ButtonType.outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: enabled && !isLoading ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 1.5),
          ),
          child: child,
        ),
      );
    }

    if (_type == _ButtonType.outlinedFilled) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: enabled && !isLoading ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: color.withOpacity(0.08),
            side: BorderSide(color: color.withOpacity(0.3), width: 1),
          ),
          child: child,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
        child: child,
      ),
    );
  }
}

enum _ButtonType { primary, outlined, outlinedFilled }
