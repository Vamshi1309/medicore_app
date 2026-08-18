import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/status_badge.dart';

/// ---------------------------------------------------------------------
/// AppointmentStatus enum -> drives StatusBadge colors/label
/// ---------------------------------------------------------------------
enum AppointmentStatus {
  confirmed,
  pending,
  cancelled,
  completed,
}

extension AppointmentStatusX on AppointmentStatus {
  String get label {
    switch (this) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';

      case AppointmentStatus.pending:
        return 'Pending';

      case AppointmentStatus.cancelled:
        return 'Cancelled';

      case AppointmentStatus.completed:
        return 'Completed';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case AppointmentStatus.confirmed:
        return const Color(0xFFDFF7E8);

      case AppointmentStatus.pending:
        return const Color(0xFFFFF4D9);

      case AppointmentStatus.cancelled:
        return const Color(0xFFFDE2E1);

      case AppointmentStatus.completed:
        return const Color(0xFFEDEDED);
    }
  }

  Color get textColor {
    switch (this) {
      case AppointmentStatus.confirmed:
        return const Color(0xFF1E8E3E);

      case AppointmentStatus.pending:
        return const Color(0xFFB98900);

      case AppointmentStatus.cancelled:
        return const Color(0xFFD93025);

      case AppointmentStatus.completed:
        return const Color(0xFF6B6B6B);
    }
  }
}

/// ---------------------------------------------------------------------
/// AppointmentCard — reusable card widget
/// ---------------------------------------------------------------------
class AppointmentCard extends StatelessWidget {
  final String name;
  final String subtitle; // e.g. "Cardiology"
  final String date; // e.g. "Today"
  final String time; // e.g. "10:30 AM"
  final AppointmentStatus status;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onRescheduleTap;
  final VoidCallback? onCancelTap;

  const AppointmentCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.date,
    required this.time,
    required this.status,
    this.onDetailsTap,
    this.onRescheduleTap,
    this.onCancelTap,
  });

  String get _initial =>
      name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Column(
        children: [
          Padding(
            
            padding: const EdgeInsets.only(top:16, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Initials avatar
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFE8ECFB),
                      child: Text(
                        _initial,
                        style: const TextStyle(
                          color: Color(0xFF3C4CAD),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
            
                    // Name + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF8A8A8A),
                            ),
                          ),
                        ],
                      ),
                    ),
            
                    // Status badge (imported from status_badge.dart)
                    StatusBadge(
                      status: status.label,
                      backgroundColor: status.backgroundColor,
                      textColor: status.textColor,
                      fontSize: 12,
                    ),
                  ],
                ),
            
                const SizedBox(height: 14),
            
                // Date & time row
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 15,
                      color: Color(0xFF8A8A8A),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.access_time,
                      size: 15,
                      color: Color(0xFF8A8A8A),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5C5C5C),
                      ),
                    ),
                  ],
                ),
            
                const SizedBox(height: 12),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey[400]),

          // Action buttons
          SizedBox(
            height: 36,
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.info_outline,
                    label: 'Details',
                    color: const Color(0xFF3B6FE0),
                    onTap: onDetailsTap,
                  ),
                ),

                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.grey[400],
                ),

                Expanded(
                  child: _ActionButton(
                    icon: Icons.sync,
                    label: 'Reschedule',
                    color: const Color(0xFF1E8E7E),
                    onTap: onRescheduleTap,
                  ),
                ),

                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.grey[400],
                ),

                Expanded(
                  child: _ActionButton(
                    icon: Icons.close,
                    label: 'Cancel',
                    color: const Color(0xFFD93025),
                    onTap: onCancelTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
