import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/theme/app_colors.dart';

/// Simple label/value pair rendered as a row inside [InfoSectionCard].
class InfoRowData {
  final String label;
  final String value;

  const InfoRowData({required this.label, required this.value});
}

/// Reusable card used for "Personal Information", "Medical Information",
/// or any other label/value grouped section.
///
/// Usage:
/// ```dart
/// InfoSectionCard(
///   icon: Icons.person_outline,
///   title: 'Personal Information',
///   rows: const [
///     InfoRowData(label: 'Full Name', value: 'Vamshi Garu'),
///     InfoRowData(label: 'Phone', value: '+91 98765 43210'),
///   ],
/// )
/// ```
class InfoSectionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final List<InfoRowData> rows;

  const InfoSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.rows,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.xs),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSizes.sm),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),
          for (int i = 0; i < rows.length; i++) ...[
            _InfoRowTile(row: rows[i]),
            if (i != rows.length - 1) ...[
              const SizedBox(height: AppSizes.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSizes.sm),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoRowTile extends StatelessWidget {
  final InfoRowData row;

  const _InfoRowTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          row.label,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(width: AppSizes.sm),
        Flexible(
          child: Text(
            row.value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}