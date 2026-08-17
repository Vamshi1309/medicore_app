import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/dashboard/mock%20data/Appointment.dart';
import 'package:frontend/features/dashboard/widgets/custom_app_bar.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/dashboard/widgets/dashboard_card.dart';
import 'package:frontend/features/dashboard/widgets/dashboard_outlined_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int currentIndex = 0;
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
      body: SingleChildScrollView(
        child: Padding(
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
              Text("Actions", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 15),
              PrimaryButton(
                text: "Book Appointment",
                icon: LucideIcons.calendarPlus300Dir,
                color: Colors.blue.shade700,
                onPressed: () {},
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
              SizedBox(height: 8),
              ListView.builder(
                itemCount: min(appointments.length, 5),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final appointment = appointments[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        // Doctor image
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue.shade50,
                          child: Text(
                            appointment.doctorName
                                .replaceFirst('Dr. ', '')
                                .substring(0, 1),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Doctor information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.doctorName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                '${appointment.specialty} · ${appointment.dateTime}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Status
                        StatusBadge(
                          status: appointment.status,
                          fontSize: 11,
                          icon: statusIcon(appointment.status),
                          backgroundColor: statusBackgroundColor(
                            appointment.status,
                          ),
                          textColor: statusTextColor(appointment.status),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
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

  Color statusBackgroundColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green.shade100;

      case "Pending":
        return Colors.amber.shade100;

      case "Cancelled":
        return Colors.red.shade100;

      default:
        return Colors.grey.shade100;
    }
  }

  Color statusTextColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green.shade600;

      case "Pending":
        return Colors.amber.shade700;

      case "Cancelled":
        return Colors.red.shade600;

      default:
        return Colors.grey.shade600;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "Confirmed":
        return LucideIcons.circleCheck;

      case "Pending":
        return LucideIcons.clock;

      case "Cancelled":
        return LucideIcons.circleX;

      default:
        return LucideIcons.circleHelp;
    }
  }

  final List<Appointment> appointments = [
    Appointment(
      doctorName: 'Dr. Sarah Johnson',
      specialty: 'Cardiology',
      dateTime: 'Today, 10:30 AM',
      status: 'Confirmed',
    ),
    Appointment(
      doctorName: 'Dr. Michael Chen',
      specialty: 'General',
      dateTime: 'Dec 18, 2:00 PM',
      status: 'Pending',
    ),
    Appointment(
      doctorName: 'Dr. Emily Davis',
      specialty: 'Dermatology',
      dateTime: 'Dec 19, 11:00 AM',
      status: 'Confirmed',
    ),
    Appointment(
      doctorName: 'Dr. Robert Wilson',
      specialty: 'Orthopedics',
      dateTime: 'Dec 20, 3:30 PM',
      status: 'Cancelled',
    ),
    Appointment(
      doctorName: 'Dr. Olivia Martinez',
      specialty: 'Neurology',
      dateTime: 'Dec 21, 9:00 AM',
      status: 'Confirmed',
    ),
    Appointment(
      doctorName: 'Dr. James Anderson',
      specialty: 'Pediatrics',
      dateTime: 'Dec 22, 1:30 PM',
      status: 'Pending',
    ),
    Appointment(
      doctorName: 'Dr. Sophia Taylor',
      specialty: 'Gynecology',
      dateTime: 'Dec 23, 10:00 AM',
      status: 'Confirmed',
    ),
    Appointment(
      doctorName: 'Dr. Daniel Brown',
      specialty: 'ENT',
      dateTime: 'Dec 24, 4:00 PM',
      status: 'Pending',
    ),
  ];
}
