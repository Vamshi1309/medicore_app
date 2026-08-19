import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';

class RecordlabReportCard extends StatelessWidget {
  final String reportName;
  final String doctorName;
  final String date;
  final String notes;
  final VoidCallback? onDownload;

  const RecordlabReportCard({
    super.key,
    required this.reportName,
    required this.doctorName,
    required this.date,
    required this.notes,
    this.onDownload,
  });

  String get _initials {
    final cleaned = doctorName.trim();

    if (cleaned.isEmpty) return '?';

    final parts = cleaned.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts[0][0].toUpperCase()}'
        '${parts[1][0].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2F6CF6);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 12,
        right: 12
      ),
      child: AppCard(
        bgColor: Colors.white,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --------------------------------
            // TOP SECTION
            // --------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: const Color(0xFFEAF1FF),
                  child: Text(
                    _initials,
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reportName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2430),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        doctorName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6F7785),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6F7785),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // --------------------------------
            // DOCTOR NOTES
            // --------------------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                notes,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: Color(0xFF4B5563),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------
            // DOWNLOAD BUTTON
            // --------------------------------
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onDownload,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: 16,
                        color: primaryColor,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'PDF',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}