import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String experienceInYears;
  final String speciality;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color color;

  const DoctorCard({
    super.key,
    required this.name,
    required this.experienceInYears,
    required this.speciality,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  String get initial => name[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      border: isSelected
          ? const BorderSide(color: Colors.blue, width: 2)
          : BorderSide.none,
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Text(initial, style: const TextStyle(color: Colors.black)),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  speciality,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.grey500),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 14,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "$experienceInYears years experience",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isSelected)
            const Icon(LucideIcons.circleCheck, color: Colors.blue, size: 24),
        ],
      ),
    );
  }
}
