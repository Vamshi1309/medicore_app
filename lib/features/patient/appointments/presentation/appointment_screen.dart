import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:frontend/features/patient/dashboard/data/models/appointment_response.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/appointment_provider.dart';
import 'package:frontend/features/patient/widgets/app_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum AppointmentFilter { all, upcoming, previous, cancelled }

class AppointmentScreen extends ConsumerStatefulWidget {
  const AppointmentScreen({super.key});

  @override
  ConsumerState<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends ConsumerState<AppointmentScreen> {
  AppointmentFilter selectedFilter = AppointmentFilter.all;

  @override
  void initState() {
    super.initState();

    ref.listenManual(patientAppointmentsProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : "Something went wrong";

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  // ---------------------------------------------------------------------------
  // FILTER HELPERS
  // ---------------------------------------------------------------------------

  List<AppointmentResponse> getUpcomingAppointments(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.pending ||
          appointment.status == AppointmentStatus.confirmed;
    }).toList();
  }

  List<AppointmentResponse> getPreviousAppointments(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.completed;
    }).toList();
  }

  List<AppointmentResponse> getCancelledAppointments(
    List<AppointmentResponse> appointments,
  ) {
    return appointments.where((appointment) {
      return appointment.status == AppointmentStatus.cancelled ||
          appointment.status == AppointmentStatus.noShow;
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(patientAppointmentsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // ========================= HEADER =========================
            AppHeader(
              title: "My Appointments",
              statCards: appointmentsAsync.when(
                loading: () => const [
                  StatCard(
                    count: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    heading: "upcoming",
                  ),
                  StatCard(
                    count: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    heading: "previous",
                  ),
                  StatCard(
                    count: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    heading: "cancelled",
                  ),
                ],

                error: (_, __) => const [
                  StatCard(
                    count: Text(
                      "0",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    heading: "upcoming",
                  ),
                  StatCard(
                    count: Text(
                      "0",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    heading: "previous",
                  ),
                  StatCard(
                    count: Text(
                      "0",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    heading: "cancelled",
                  ),
                ],

                data: (appointments) {
                  final upcoming = getUpcomingAppointments(appointments);
                  final previous = getPreviousAppointments(appointments);
                  final cancelled = getCancelledAppointments(appointments);

                  return [
                    StatCard(
                      count: Text(
                        upcoming.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      heading: "upcoming",
                    ),
                    StatCard(
                      count: Text(
                        previous.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      heading: "previous",
                    ),
                    StatCard(
                      count: Text(
                        cancelled.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      heading: "cancelled",
                    ),
                  ];
                },
              ),
            ),

            // ========================= FILTER CHIPS =========================
            Container(
              width: double.infinity,
              color: const Color(0xFFF5F6F8),
              padding: const EdgeInsets.fromLTRB(12, 8, 0, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip("All", AppointmentFilter.all),
                    const SizedBox(width: 8),
                    _filterChip("Upcoming", AppointmentFilter.upcoming),
                    const SizedBox(width: 8),
                    _filterChip("Previous", AppointmentFilter.previous),
                    const SizedBox(width: 8),
                    _filterChip("Cancelled", AppointmentFilter.cancelled),
                  ],
                ),
              ),
            ),

            // ========================= APPOINTMENTS =========================
            Expanded(
              child: appointmentsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (_, __) =>
                    const Center(child: Text("Failed to load appointments")),

                data: (appointments) {
                  final filteredAppointments = getFilteredAppointments(
                    appointments,
                  );

                  if (appointments.isEmpty || filteredAppointments.isEmpty) {
                    final emptyStateTitle = switch (selectedFilter) {
                      AppointmentFilter.all => 'No Appointments',
                      AppointmentFilter.upcoming => 'No Upcoming Appointments',
                      AppointmentFilter.previous => 'No Previous Appointments',
                      AppointmentFilter.cancelled =>
                        'No Cancelled Appointments',
                    };

                    final emptyStateSubtitle = switch (selectedFilter) {
                      AppointmentFilter.all =>
                        'You don’t have any appointments yet.',
                      AppointmentFilter.upcoming =>
                        'You have no upcoming appointments right now.',
                      AppointmentFilter.previous =>
                        'You have no previous appointments yet.',
                      AppointmentFilter.cancelled =>
                        'There are no cancelled appointments to show.',
                    };

                    return SizedBox.expand(
                      child: Center(
                        child: EmptyState(
                          icon: LucideIcons.calendarX,
                          title: emptyStateTitle,
                          subtitle: emptyStateSubtitle,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: buildSelectedContent(appointments),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<AppointmentResponse> getFilteredAppointments(
    List<AppointmentResponse> appointments,
  ) {
    switch (selectedFilter) {
      case AppointmentFilter.all:
        return appointments;
      case AppointmentFilter.upcoming:
        return getUpcomingAppointments(appointments);
      case AppointmentFilter.previous:
        return getPreviousAppointments(appointments);
      case AppointmentFilter.cancelled:
        return getCancelledAppointments(appointments);
    }
  }

  // ---------------------------------------------------------------------------
  // FILTERED CONTENT
  // ---------------------------------------------------------------------------

  Widget buildSelectedContent(List<AppointmentResponse> appointments) {
    final upcoming = getUpcomingAppointments(appointments);
    final previous = getPreviousAppointments(appointments);
    final cancelled = getCancelledAppointments(appointments);

    switch (selectedFilter) {
      case AppointmentFilter.all:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (upcoming.isNotEmpty) ...[
              const Text(
                "Upcoming",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(upcoming),
            ],

            if (previous.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "Previous",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(previous),
            ],

            if (cancelled.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                "Cancelled",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              buildAppointmentList(cancelled),
            ],
          ],
        );

      case AppointmentFilter.upcoming:
        return buildAppointmentList(upcoming);

      case AppointmentFilter.previous:
        return buildAppointmentList(previous);

      case AppointmentFilter.cancelled:
        return buildAppointmentList(cancelled);
    }
  }

  // ---------------------------------------------------------------------------
  // APPOINTMENT LIST
  // ---------------------------------------------------------------------------

  Widget buildAppointmentList(List<AppointmentResponse> appointments) {
    return ListView.builder(
      itemCount: appointments.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final appointment = appointments[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AppointmentCard(
            name: appointment.doctorName,
            subtitle: appointment.doctorSpecialization ?? "",
            date: formatDate(appointment.scheduledAt),
            time: formatTime(appointment.scheduledAt),
            status: appointment.status,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER CHIP
  // ---------------------------------------------------------------------------

  Widget _filterChip(String label, AppointmentFilter filter) {
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

// -----------------------------------------------------------------------------
// FORMATTERS
// -----------------------------------------------------------------------------

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
