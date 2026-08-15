import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String userRole;

  const CustomAppBar({
    super.key,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final user = auth.user;

    final name = user?.name;
    final displayName = name ?? "Sir/Ma'am";

    return AppBar(
      toolbarHeight: 80,
      titleSpacing: 16,
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blueGrey,
            radius: 23,
            child: Text(
              name != null && name.isNotEmpty
                  ? name.substring(0, 1).toUpperCase()
                  : "N",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isMorning() ? "Good Morning," : "Good Evening,",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color.fromARGB(255, 87, 93, 100),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Text(
                name != null ? "$displayName Garu" : displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),

      actions: [
        StatusBadge(
          status: userRole,
          backgroundColor: AppColors.primary.withAlpha(55),
          textColor: Colors.blue.shade500,
        ),

        const SizedBox(width: 12),

        Badge(
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blueGrey.withAlpha(75),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                // Open notifications
              },
              icon: const Icon(
                Icons.notifications_outlined,
                size: 25,
                color: Colors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),
      ],
    );
  }

  bool isMorning() {
    final hour = DateTime.now().hour;
    return hour >= 5 && hour < 12;
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}