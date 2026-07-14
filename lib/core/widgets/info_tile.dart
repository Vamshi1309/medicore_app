import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(width: AppSizes.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: AppSizes.xs),
                  Text(value, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),

            if (trailing != null) ...[
              const SizedBox(width: AppSizes.md),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
