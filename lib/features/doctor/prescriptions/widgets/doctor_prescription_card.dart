import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DoctorsPrescriptionCard extends StatelessWidget {
  final String patientName;
  final String reason;
  final String date;
  final int medicineCount;
  final VoidCallback? onDownload;

  const DoctorsPrescriptionCard({
    super.key,
    required this.patientName,
    required this.reason,
    required this.date,
    required this.medicineCount,
    required this.onDownload,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(
                  _getInitials(patientName),
                  style: const TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    reason,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade100,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Date",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: 13
                      ),
                    ),
                  ],
                ),

                Container(height: 40, width: 1, color: Colors.grey.shade400),

                Column(
                  children: [
                    Text(
                      "Medicines",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12
                      ),
                    ),
                    Text(
                      "$medicineCount items",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 40,
            child: PrimaryButton.outlinedFilled(
              text: 'Download PDF',
              onPressed: onDownload,
              prefixIcon: LucideIcons.download,
            ),
          ),
        ],
      ),
    );
  }
}
