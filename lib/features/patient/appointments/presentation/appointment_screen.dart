import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/patient/appointments/mock%20data/appointment_model.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/patient/widgets/app_header.dart';

enum AppointmentFilter { all, upcoming, previous, cancelled }

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  AppointmentFilter selectedFilter = AppointmentFilter.all;

  List<AppointmentModel> get upcomingAppointments {
    final now = DateTime.now();

    return appointments.where((appointment) {
      return appointment.appointmentDateTime.isAfter(now) &&
          appointment.status != AppointmentStatus.cancelled;
    }).toList();
  }

  List<AppointmentModel> get previousAppointments {
    final now = DateTime.now();

    return appointments.where((appointment) {
      return appointment.appointmentDateTime.isBefore(now) &&
          appointment.status != AppointmentStatus.cancelled;
    }).toList();
  }

  List<AppointmentModel> get cancelledAppointments {
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.cancelled;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "My Appointments",
              statCards: [
                StatCard(count: "4", heading: "upcoming"),
                StatCard(count: "2", heading: "previous"),
                StatCard(count: "1", heading: "cancelled"),
              ],
            ),
            Container(
              width: double.infinity,
              color: const Color(0xFFF5F6F8),
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(label: 'All', filter: AppointmentFilter.all),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Upcoming',
                      filter: AppointmentFilter.upcoming,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Previous',
                      filter: AppointmentFilter.previous,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Cancelled',
                      filter: AppointmentFilter.cancelled,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: buildSelectedContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectedContent() {
    switch (selectedFilter) {
      case AppointmentFilter.all:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (upcomingAppointments.isNotEmpty) ...[
              const Text(
                'Upcoming',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(upcomingAppointments),
            ],

            if (previousAppointments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Previous',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(previousAppointments),
            ],

            if (cancelledAppointments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Cancelled',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(cancelledAppointments),
            ],
          ],
        );

      case AppointmentFilter.upcoming:
        return buildAppointmentList(upcomingAppointments);

      case AppointmentFilter.previous:
        return buildAppointmentList(previousAppointments);

      case AppointmentFilter.cancelled:
        return buildAppointmentList(cancelledAppointments);
    }
  }

  Widget buildAppointmentList(List<AppointmentModel> appointmentList) {
    if (appointmentList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No appointments found',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: appointmentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final appointment = appointmentList[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: AppointmentCard(
            name: appointment.doctorName,
            subtitle: appointment.specialty,
            date: formatDate(appointment.appointmentDateTime),
            time: formatTime(appointment.appointmentDateTime),
            status: appointment.status,
          ),
        );
      },
    );
  }

  Widget _filterChip({
    required String label,
    required AppointmentFilter filter,
  }) {
    final isSelected = selectedFilter == filter;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Colors.blue.shade800,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300,
      ),
      onSelected: (_) {
        setState(() {
          selectedFilter = filter;
        });
      },
    );
  }
}

String formatDate(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}/'
      '${dateTime.month.toString().padLeft(2, '0')}/'
      '${dateTime.year}';
}

String formatTime(DateTime dateTime) {
  final hour = dateTime.hour == 0
      ? 12
      : dateTime.hour > 12
      ? dateTime.hour - 12
      : dateTime.hour;

  final minute = dateTime.minute.toString().padLeft(2, '0');

  final period = dateTime.hour >= 12 ? 'PM' : 'AM';

  return '$hour:$minute $period';
}

final List<AppointmentModel> appointments = [
  AppointmentModel(
    doctorName: 'Dr. Anil Reddy',
    specialty: 'Cardiology',
    appointmentDateTime: DateTime(2026, 8, 20, 10, 0),
    status: AppointmentStatus.confirmed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Lakshmi Devi',
    specialty: 'General Medicine',
    appointmentDateTime: DateTime(2026, 8, 21, 11, 30),
    status: AppointmentStatus.pending,
  ),
  AppointmentModel(
    doctorName: 'Dr. Srinivas Rao',
    specialty: 'Dermatology',
    appointmentDateTime: DateTime(2026, 8, 22, 14, 0),
    status: AppointmentStatus.confirmed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Kiran Kumar',
    specialty: 'Orthopedics',
    appointmentDateTime: DateTime(2026, 8, 18, 15, 30),
    status: AppointmentStatus.cancelled,
  ),
  AppointmentModel(
    doctorName: 'Dr. Priya Reddy',
    specialty: 'Neurology',
    appointmentDateTime: DateTime(2026, 8, 15, 9, 0),
    status: AppointmentStatus.completed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Mahesh Babu',
    specialty: 'Pediatrics',
    appointmentDateTime: DateTime(2026, 8, 25, 13, 30),
    status: AppointmentStatus.pending,
  ),
  AppointmentModel(
    doctorName: 'Dr. Anusha Varma',
    specialty: 'Gynecology',
    appointmentDateTime: DateTime(2026, 8, 28, 10, 0),
    status: AppointmentStatus.confirmed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Sai Kishor',
    specialty: 'ENT',
    appointmentDateTime: DateTime(2026, 8, 10, 16, 0),
    status: AppointmentStatus.completed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Swathi Reddy',
    specialty: 'Ophthalmology',
    appointmentDateTime: DateTime(2026, 8, 30, 11, 0),
    status: AppointmentStatus.confirmed,
  ),
  AppointmentModel(
    doctorName: 'Dr. Venkatesh Goud',
    specialty: 'Gastroenterology',
    appointmentDateTime: DateTime(2026, 8, 12, 12, 30),
    status: AppointmentStatus.completed,
  ),
];
