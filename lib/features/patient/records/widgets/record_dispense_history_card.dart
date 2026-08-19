import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';

class RecordDispenseHistoryCard extends StatelessWidget {
  final String medicineName;
  final double price;
  final int tabletCount;
  final String pharmacistName;
  final String date;

  const RecordDispenseHistoryCard({
    super.key,
    required this.medicineName,
    required this.price,
    required this.tabletCount,
    required this.pharmacistName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF1F2430);
    // const secondaryTextColor = Color(0xFF6F7785);

    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: 6,
      ),
      child: AppCard(
        bgColor: Colors.white,
        borderRadius: BorderRadius.circular(18),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------
            // MEDICINE NAME + PRICE
            // --------------------------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    medicineName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: primaryTextColor,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F7EC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E9B50),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --------------------------------
            // DETAILS
            // --------------------------------
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.medication_outlined,
                    text: '$tabletCount tablets',
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _InfoCard(
                    icon: Icons.person_outline_rounded,
                    text: pharmacistName,
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: _InfoCard(
                    icon: Icons.calendar_today_outlined,
                    text: date,
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

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoCard({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE3E5E8),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 15,
            color: const Color(0xFF6F7785),
          ),

          const SizedBox(width: 5),

          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6F7785),
              ),
            ),
          ),
        ],
      ),
    );
  }
}