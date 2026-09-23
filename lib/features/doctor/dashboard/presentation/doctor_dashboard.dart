import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/providers/appointment_provider.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/doctor/profile/providers/doctor_profile_provider.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';

class DoctorDashboard extends ConsumerStatefulWidget {
  const DoctorDashboard({super.key});

  @override
  ConsumerState<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends ConsumerState<DoctorDashboard> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(appointmentsProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err.toString();
          AppSnackBar.error(context, message);
        },
      );
    });

    ref.listenManual(doctorProfileProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final message = err.toString();
          AppSnackBar.error(context, message);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncAppointmentsProvider = ref.watch(appointmentsProvider);

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTopHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.lg),

                      _sectionHeader('Next Appointment'),

                      const SizedBox(height: 10),

                      _buildNextAppointmentCard(context),

                      const SizedBox(height: AppSizes.lg),

                      _buildScheduleHeader(context),

                      const SizedBox(height: AppSizes.sm),

                      ..._buildTodaySchedule(asyncAppointmentsProvider),

                      const SizedBox(height: AppSizes.xxl),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTopHeader(BuildContext context) {

    final user = ref.watch(authProvider).user;

    return Container(
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
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Good Morning,',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: AppSizes.xs),
                    Text(
                      'Dr. ${user?.name ?? "Doctor"}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _specialtyBadge(),
                  ],
                ),
              ),
              Container(
                width: AppSizes.avatarMd,
                height: AppSizes.avatarMd,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'VR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: _statCardStyled(
                  '6',
                  "Today's Appointments",
                  '3 remaining',
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _statCardStyled(
                  '24',
                  'Prescriptions Written',
                  'This month',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _specialtyBadge() {
    final provider = ref.watch(doctorProfileProvider);

    return provider.when(
      loading: () => const SizedBox(
        height: 24,
        child: Center(
          child: SizedBox(
            height: 14,
            width: 14,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
        ),
      ),

      error: (error, stackTrace) => const SizedBox(),

      data: (profile) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF34D399),
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 6),

              Text(
                profile.specialization,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCardStyled(String value, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildNextAppointmentCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
            children: [
              _avatarCircleSmall('RK', const Color(0xFF3B82F6)),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Ravi Kumar',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: AppSizes.xs),
                    Text(
                      'General Checkup',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "09:00",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "AM",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(height: 25, color: Colors.white30),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.transparent,
                    minimumSize: const Size.fromHeight(35),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatarCircleSmall(String initials, Color color) {
    return CircleAvatar(
      radius: AppSizes.avatarMd / 2,
      backgroundColor: color,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildScheduleHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _sectionHeader("Today's Appointments"),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTodaySchedule(
    AsyncValue<List<AppointmentResponse>> asyncAppointments,
  ) {
    return asyncAppointments.when(
      loading: () => [const Center(child: CircularProgressIndicator())],

      error: (error, stackTrace) => [
        ErrorState(title: "Error", subtitle: error.toString()),
      ],

      data: (appointments) {
        return appointments.map((appointment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: _scheduleItem(
              initials: _getInitials(appointment.patientName),
              name: appointment.patientName,
              time: _getTime(appointment.scheduledAt),
              desc: appointment.notes,
              status: appointment.status,
            ),
          );
        }).toList();
      },
    );
  }

  Widget _scheduleItem({
    required String initials,
    required String name,
    required String time,
    required String desc,
    required AppointmentStatus status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _avatarCircleSmall(initials, const Color(0xFF3B82F6)),

          const SizedBox(width: AppSizes.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSizes.xs),

                Text(
                  '$time · $desc',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.grey700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Compact status badge
          SizedBox(
            child: StatusBadge(
              status: status.label,
              fontSize: 11,
              backgroundColor: status.backgroundColor,
              textColor: status.textColor,
              icon: status.icon,
            ),
          ),
        ],
      ),
    );
  }

  String _getTime(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String _getInitials(String name) {
    String ans = "";
    List<String> names = name.split(" ");
    if (names.length > 1) {
      ans += names.elementAt(0)[0];
      ans += names.elementAt(1)[0];
    } else {
      ans += names.elementAt(0)[0];
    }

    return ans.toUpperCase();
  }
}
