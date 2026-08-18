import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:frontend/features/patient/dashboard/home_screen.dart';
import 'package:frontend/features/patient/appointments/presentation/appointment_screen.dart';

class PatientShell extends ConsumerStatefulWidget {
  final int initialIndex;

  const PatientShell({super.key, this.initialIndex = 0});

  @override
  ConsumerState<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends ConsumerState<PatientShell> {
  late int currentIndex;

  final List<Widget> pages = const [
    HomeScreen(),
    AppointmentScreen(),
    Center(child: Text('Records')),
    Center(child: Text('Profile')),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) => setState(() => currentIndex = index),
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
