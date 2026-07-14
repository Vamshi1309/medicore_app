import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade500),
          const SizedBox(height: AppSizes.md),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSizes.sm),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: AppSizes.md), action!],
        ],
      ),
    );
  }
}
