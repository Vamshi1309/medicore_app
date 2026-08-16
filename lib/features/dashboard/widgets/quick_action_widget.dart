import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuickActionWidget extends ConsumerWidget {
  final String text;
  final IconData icon;
  final Color color;
  final Color colorbg;

  const QuickActionWidget({
    super.key,
    required this.color,
    required this.colorbg,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          height: 60,
          width: 55,
          decoration: BoxDecoration(
            color: colorbg,
            borderRadius: BorderRadius.all(Radius.circular(13)),
          ),
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
