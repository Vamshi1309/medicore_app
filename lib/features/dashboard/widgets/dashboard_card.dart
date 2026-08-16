import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_card.dart';

class DashboardCard extends ConsumerWidget {
  final List<Widget> children;
  final String role;
  final Color color;
  final String buttonText;
  final Color textFontColor;
  final Color textBgColor; 
  final VoidCallback? onPressed;

  const DashboardCard({
    super.key,
    required this.children,
    required this.role,
    required this.textFontColor,
    required this.textBgColor,
    required this.color,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      bgColor: color,
      borderRadius: const BorderRadius.all(
        Radius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
              ],
            ),
          ),

          const SizedBox(width: 16),

          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: textBgColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                color: textFontColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}