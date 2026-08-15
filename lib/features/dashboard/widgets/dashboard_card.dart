import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_card.dart';

class DashboardCard extends ConsumerWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      bgColor: Colors.blue.shade500,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Next appointment",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 5),
              Text(
                "Dr. Laxmi Dasari",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Today, 10:30 Am - dermatology",
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          Spacer(),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "View",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
