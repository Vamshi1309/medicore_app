import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/providers/all_appointments_provider.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/receptionist/widgets/receptionist_app_card.dart';

class ReceptionistAppointmentsScreen extends ConsumerWidget {
  const ReceptionistAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentState = ref.watch(allAppointmentsProvider);

    return appointmentState.when(
      data: (data) {
        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              _buildTopHeader(context),

              const TabBar(
                dividerColor: Colors.transparent,
                
                tabs: [
                  Tab(text: 'Pending'),
                  Tab(text: 'Confirmed'),
                  Tab(text: 'Cancelled'),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    _buildAppointmentList(data, AppointmentStatus.pending),
                    _buildAppointmentList(data, AppointmentStatus.confirmed),
                    _buildAppointmentList(data, AppointmentStatus.cancelled),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return Center(
          child: ErrorState(title: "Error", subtitle: error.toString()),
        );
      },
      loading: () {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAppointmentList(
    List<AppointmentResponse> appointments,
    AppointmentStatus status,
  ) {
    final filteredAppointments = appointments
        .where((appointment) => appointment.status == status)
        .toList();

    if (filteredAppointments.isEmpty) {
      return const Center(child: Text('No appointments found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ReceptionistAppCard(appointment: filteredAppointments[index]),
        );
      },
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 32,
          left: AppSizes.lg,
          right: AppSizes.lg,
          bottom: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //specialtyBadge(),
                    ],
                  ),
                ),
                StatusBadge(
                  status: "7 Total",
                  backgroundColor: Colors.white24,
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 10),
            AppSearchBar(hintText: "Search Doctor..."),
          ],
        ),
      ),
    );
  }
}
