import 'package:flutter/material.dart';

class DoctorHeader extends StatelessWidget {
  final String header;
  final String subHeader;
  final Widget? child;

  const DoctorHeader({
    super.key,
    required this.header,
    required this.subHeader,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade600,
            Colors.blue.shade500,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: Colors.white),
          ),

          const SizedBox(height: 6),

          Text(
            subHeader,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Colors.white60,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ?child,
        ],
      ),
    );
  }
}
