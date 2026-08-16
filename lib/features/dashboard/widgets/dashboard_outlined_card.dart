import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardOutlinedCard extends ConsumerWidget {
  final Color color;
  final IconData icon;
  final String count;
  final String text;

  const DashboardOutlinedCard({
    super.key,
    required this.color,
    required this.icon,
    required this.count,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 125,
      width: 115,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      padding: EdgeInsets.symmetric(horizontal:12,vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.black),
          ),
          Text(
            count,
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontSize: 30),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
