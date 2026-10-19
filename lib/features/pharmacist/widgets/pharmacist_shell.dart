import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PharmacistShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PharmacistShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 60,
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              );
            }
            return const TextStyle(fontSize: 11, color: Colors.grey);
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.blue);
            }
            return const IconThemeData(color: Colors.grey);
          }),
        ),
        child: NavigationBar(
          height: 60,
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(icon: Icon(LucideIcons.house), label: 'Home'),
            NavigationDestination(
              icon: Icon(LucideIcons.fileText),
              label: 'Prescriptions',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.package),
              label: 'Inventory',
            ),
            NavigationDestination(
              icon: Icon(LucideIcons.userRound),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
