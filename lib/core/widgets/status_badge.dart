import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.status,
    required this.backgroundColor,
    this.height,
    this.fontSize,
    this.width,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: textColor),
            const SizedBox(width: 4),
          ],

          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 15,
            ),
          ),
        ],
      ),
    );
  }
}
