import 'package:flutter/material.dart';
import 'package:frontend/features/doctor/appointments/widgets/doctor_appointment_card.dart';
import 'package:frontend/features/doctor/widgets/doctor_header.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class DoctorAppointmentScreen extends StatefulWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  State<DoctorAppointmentScreen> createState() =>
      _DoctorAppointmentScreenState();
}

class _DoctorAppointmentScreenState extends State<DoctorAppointmentScreen> {
  final List<String> tabBarOptions = ['all', 'today', 'upcoming', 'completed'];

  List<DoctorAppointment> get filteredAppointments {
    switch (selectedOption) {
      case 'today':
        return appointments
            .where((appointment) => appointment.date == 'Today')
            .toList();

      case 'upcoming':
        return appointments
            .where((appointment) => appointment.date != 'Today')
            .toList();

      case 'completed':
        return appointments
            .where(
              (appointment) =>
                  appointment.status == AppointmentStatus.completed,
            )
            .toList();

      case 'all':
      default:
        return appointments;
    }
  }

  String selectedOption = 'all';

  Widget _buildSegment(String value, String label) {
    final isSelected = selectedOption == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedOption = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.blue.shade600 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // ============================================================
            // HEADER
            // ============================================================
            DoctorHeader(
              header: "Appointments",
              subHeader: "6 Total . 3 Today",
              child: Container(
                height: 42,
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _buildSegment('all', 'All'),
                    _buildSegment('today', 'Today'),
                    _buildSegment('upcoming', 'Upcoming'),
                    _buildSegment('completed', 'Completed'),
                  ],
                ),
              ),
            ),

            // ============================================================
            // APPOINTMENTS
            // ============================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  children: filteredAppointments.map((appointment) {
                    return DoctorAppointmentCard(
                      patientName: appointment.patientName,
                      initials: appointment.initials,
                      appointmentType: appointment.appointmentType,
                      age: appointment.age,
                      date: appointment.date,
                      time: appointment.time,
                      status: appointment.status,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<DoctorAppointment> appointments = [
  DoctorAppointment(
    patientName: 'Ravi Kumar',
    initials: 'RK',
    appointmentType: 'General Checkup',
    age: 34,
    date: 'Today',
    time: '09:00 AM',
    status: AppointmentStatus.pending,
  ),

  DoctorAppointment(
    patientName: 'Anjali Sharma',
    initials: 'AS',
    appointmentType: 'Follow-up',
    age: 28,
    date: 'Today',
    time: '11:00 AM',
    status: AppointmentStatus.confirmed,
  ),

  DoctorAppointment(
    patientName: 'Rahul Reddy',
    initials: 'RR',
    appointmentType: 'Dental Consultation',
    age: 41,
    date: 'Today',
    time: '03:00 PM',
    status: AppointmentStatus.completed,
  ),

  DoctorAppointment(
    patientName: 'Priya Singh',
    initials: 'PS',
    appointmentType: 'General Checkup',
    age: 31,
    date: 'Tomorrow',
    time: '10:00 AM',
    status: AppointmentStatus.confirmed,
  ),

  DoctorAppointment(
    patientName: 'Kiran Rao',
    initials: 'KR',
    appointmentType: 'Follow-up',
    age: 45,
    date: 'Tomorrow',
    time: '02:00 PM',
    status: AppointmentStatus.pending,
  ),

  DoctorAppointment(
    patientName: 'Sneha Reddy',
    initials: 'SR',
    appointmentType: 'Consultation',
    age: 26,
    date: 'Sep 12',
    time: '04:00 PM',
    status: AppointmentStatus.confirmed,
  ),
];

class DoctorAppointment {
  final String patientName;
  final String initials;
  final String appointmentType;
  final int age;
  final String date;
  final String time;
  final AppointmentStatus status;

  DoctorAppointment({
    required this.patientName,
    required this.initials,
    required this.appointmentType,
    required this.age,
    required this.date,
    required this.time,
    required this.status,
  });
}
