import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final String? greeting;
  final List<StatCard> statCards;
  final VoidCallback? onNotificationTap;
  final bool showNotificationBadge;

  const AppHeader({
    super.key,
    required this.title,
    required this.statCards,
    this.greeting,
    this.onNotificationTap,
    this.showNotificationBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 180),
      padding: const EdgeInsets.only(top: 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C4BC4),
            Color(0xFF1A6BFF),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (greeting != null) ...[
                        Text(
                          greeting!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],

                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Badge(
                  isLabelVisible: showNotificationBadge,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onNotificationTap,
                      borderRadius: BorderRadius.circular(25),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white.withAlpha(60),
                        child: const Icon(
                          LucideIcons.bell500,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < statCards.length; i++) ...[
                      statCards[i],

                      if (i != statCards.length - 1)
                        const SizedBox(width: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String count;
  final String heading;

  const StatCard({
    super.key,
    required this.count,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 60,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(60),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            heading,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}