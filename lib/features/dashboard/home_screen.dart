import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/features/dashboard/widgets/custom_app_bar.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/features/dashboard/widgets/dashboard_outlined_card.dart';
import 'package:frontend/features/dashboard/widgets/quick_action_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 1;
  @override
  initState() {
    super.initState();

    ref.listenManual(authProvider, (prev, next) {
      if (next.error != null) {
        AppSnackBar.error(context, next.error!);
      }

      if (next.message != null) {
        AppSnackBar.success(context, next.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userRole: ref.watch(authProvider).user?.role.name ?? "No role",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            DashboardCard(
              role: ref.read(authProvider).user?.role.name ?? "No user",
              color: Colors.blue.shade700,
              buttonText: 'view',
              textFontColor: Colors.blue.shade700,
              textBgColor: Colors.white,
              onPressed: () {},
              children: [
                Text(
                  "Next Appointment",
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 5),
                Text(
                  "Dr. Laxmi Dasari",
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Today, 10:30 AM - Dermatology",
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardOutlinedCard(
                  color: Colors.blue.shade100,
                  icon: LucideIcons.calendarCheck600Dir,
                  count: "5",
                  text: "Upcoming",
                ),
                DashboardOutlinedCard(
                  color: Colors.lightBlueAccent.shade200,
                  icon: LucideIcons.fileText600Dir,
                  count: "3",
                  text: "Prescriptions",
                ),
                DashboardOutlinedCard(
                  color: Colors.green.shade100,
                  icon: LucideIcons.clipboard600,
                  count: "7",
                  text: "Reports",
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Quick Actions",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                QuickActionWidget(
                  color: Colors.blue.shade700,
                  colorbg: Colors.lightBlue.shade100,
                  text: 'Book Appointment',
                  icon: LucideIcons.calendarPlus300,
                ),
                QuickActionWidget(
                  color: Colors.greenAccent.shade700,
                  colorbg: Colors.green.shade100,
                  text: 'Prescriptions',
                  icon: LucideIcons.pill300,
                ),
                QuickActionWidget(
                  color: Colors.amberAccent.shade700,
                  colorbg: Colors.amber.shade100,
                  text: 'Reports',
                  icon: LucideIcons.clipboardList300,
                ),
                QuickActionWidget(
                  color: Colors.blueGrey.shade700,
                  colorbg: Colors.grey.shade200,
                  text: 'My Profile',
                  icon: LucideIcons.user300,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Upcoming Appointments",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "See all",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.blue.shade700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        backgroundColor: Colors.white,

        indicatorColor: Colors.transparent,

        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,

        destinations: [
          NavigationDestination(
            icon: Icon(LucideIcons.house, color: Colors.grey.shade400),
            selectedIcon: const Icon(LucideIcons.house, color: Colors.blue),
            label: 'Home',
          ),

          NavigationDestination(
            icon: Icon(LucideIcons.calendar, color: Colors.grey.shade400),
            selectedIcon: const Icon(LucideIcons.calendar, color: Colors.blue),
            label: 'Appointments',
          ),

          NavigationDestination(
            icon: Icon(LucideIcons.fileText, color: Colors.grey.shade400),
            selectedIcon: const Icon(LucideIcons.fileText, color: Colors.blue),
            label: 'Records',
          ),

          NavigationDestination(
            icon: Icon(LucideIcons.userRound, color: Colors.grey.shade400),
            selectedIcon: const Icon(LucideIcons.userRound, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
