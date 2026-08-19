import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';

class RecordPrescriptionCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String date;
  final int medicineCount;
  final VoidCallback? onDownload;

  const RecordPrescriptionCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.medicineCount,
    this.onDownload,
  });

  String get _initials {
    final cleaned = doctorName.trim();

    if (cleaned.isEmpty) return '?';

    final trimmed = cleaned.split(RegExp(r'\s+'));

    if (trimmed.length == 1) {
      return cleaned[0].toUpperCase();
    }

    return '${trimmed[0][0].toUpperCase()}'
        '${trimmed[1][0].toUpperCase()}';
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
          children: [
            // -----------------------------
            // TOP SECTION
            // -----------------------------
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
                        doctorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2430),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        specialty,
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

            // -----------------------------
            // DIVIDER
            // -----------------------------
            const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),

            const SizedBox(height: 14),

            // -----------------------------
            // BOTTOM SECTION
            // -----------------------------
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$medicineCount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade700,
                          ),
                        ),
                        const TextSpan(
                          text: ' medicines prescribed',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: onDownload,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
