import 'package:flutter/material.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/features/doctor/appointments/presentation/doctor_appointment_screen.dart';
import 'package:frontend/features/doctor/dashboard/presentation/doctor_dashboard.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shell that hosts the bottom navigation bar for all doctor tabs.
/// Mirrors the PatientShell(initialIndex: i) pattern already used
/// for patient routes. Each tab is a route (see AppRoutes.doctorHome,
/// doctorAppointments, doctorPatients, doctorPrescriptions, doctorProfile)
/// so the URL and system back button behave correctly with go_router.
class DoctorShell extends StatelessWidget {
  final int initialIndex;

  const DoctorShell({super.key, required this.initialIndex});

  static const List<String> _routes = [
    AppRoutes.doctorHome,
    AppRoutes.doctorAppointments,
    AppRoutes.doctorPatients,
    AppRoutes.doctorPrescriptions,
    AppRoutes.doctorProfile,
  ];

  // Replace these placeholder screens with your real ones as you build them.
  static const List<Widget> _tabs = [
    DoctorDashboard(),
    DoctorAppointmentScreen(),
    _PlaceholderScreen(title: 'Patients'),
    _PlaceholderScreen(title: 'Prescriptions'),
    _PlaceholderScreen(title: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: initialIndex, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: initialIndex,
        onDestinationSelected: (index) {
          if (index == initialIndex) return;
          context.go(_routes[index]);
        },
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.house, color: Colors.grey),
            selectedIcon: Icon(LucideIcons.house, color: Colors.blue),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.calendar, color: Colors.grey),
            selectedIcon: Icon(LucideIcons.calendar, color: Colors.blue),
            label: 'Appointments',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.users, color: Colors.grey),
            selectedIcon: Icon(LucideIcons.users, color: Colors.blue),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.fileText, color: Colors.grey),
            selectedIcon: Icon(LucideIcons.fileText, color: Colors.blue),
            label: 'Prescriptions',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.userRound, color: Colors.grey),
            selectedIcon: Icon(LucideIcons.userRound, color: Colors.blue),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Center(child: Text('$title — coming soon')));
  }
}
