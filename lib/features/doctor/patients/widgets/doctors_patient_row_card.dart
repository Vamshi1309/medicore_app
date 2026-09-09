import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:intl/intl.dart';

class DoctorsPatientRowCard extends StatelessWidget {
  final String patinetName;
  final DateTime lastVisited;
  final int totalVisits;

  const DoctorsPatientRowCard({
    super.key,
    required this.patinetName,
    required this.lastVisited,
    required this.totalVisits,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: AppCard(
        child: Row(
          children: [
            CircleAvatar(
              child: Text(
                _initials(patinetName),
                style: TextStyle(fontSize: 14),
              ),
            ),
            Spacer(flex: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patinetName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  "Last Visited: ${DateFormat("MM dd, yyyy").format(lastVisited)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            Spacer(flex: 6),

            StatusBadge(
              status: "$totalVisits visits",
              backgroundColor: Colors.blue.shade100,
              textColor: Colors.blue.shade700,
              fontSize: 10,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
