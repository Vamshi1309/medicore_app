import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RadiologistShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RadiologistShell({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 72,
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFEAF2FF),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2B6EF7),
              );
            }
            return const TextStyle(
              fontSize: 11,
              color: Color(0xFF8A8F9D),
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Color(0xFF2B6EF7));
            }
            return const IconThemeData(color: Color(0xFF8A8F9D));
          }),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: const [
            NavigationDestination(icon: Icon(LucideIcons.home), label: 'Home'),
            NavigationDestination(icon: Icon(LucideIcons.upload), label: 'Upload'),
            NavigationDestination(icon: Icon(LucideIcons.fileText), label: 'My Reports'),
            NavigationDestination(icon: Icon(LucideIcons.userRound), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
