import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_radius.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? bgColor;
  final EdgeInsetsGeometry? margin;

  const AppCard({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.bgColor,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? AppRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.md,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
