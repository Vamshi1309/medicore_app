import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_text_styles.dart';

class PharmacistDashboard extends StatelessWidget {
  const PharmacistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 18, 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3E6BFF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
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
                              Text(
                                'Good morning',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Hello, Priya',
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pharmacist',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _MetricCard(value: '12', label: 'To dispense'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(value: '5', label: 'Low stock'),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(value: '28', label: 'Dispensed'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFEFEFFA),
                          foregroundColor: const Color(0xFF2852D8),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          '+ Review pending prescriptions',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 15,
                            color: const Color(0xFF2852D8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 6),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Low stock alerts',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: const Color(0xFF2E2F42),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'View inventory',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _AlertRow(
                        name: 'Amoxicillin 500mg',
                        subtitle: 'Only 8 units remaining',
                        level: 'Low',
                        accent: Color(0xFFF9D08A),
                      ),
                      const SizedBox(height: 10),
                      _AlertRow(
                        name: 'Azithromycin 500mg',
                        subtitle: 'Only 6 units remaining',
                        level: 'Low',
                        accent: Color(0xFFF9D08A),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent dispenses',
                            style: AppTextStyles.titleLarge.copyWith(
                              color: const Color(0xFF2E2F42),
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'See all',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [
                            const _RecentDispenseRow(
                              initials: 'SP',
                              name: 'Sneha Pillai',
                              details: '3 medicines · ₹284',
                              time: '10:24 AM',
                              color: Color(0xFF4CB6F5),
                            ),
                            const _RecentDispenseRow(
                              initials: 'KM',
                              name: 'Karan Malhotra',
                              details: '2 medicines · ₹156',
                              time: '09:42 AM',
                              color: Color(0xFF56C7C0),
                            ),
                            const _RecentDispenseRow(
                              initials: 'DV',
                              name: 'Diya Verma',
                              details: '4 medicines · ₹492',
                              time: 'Yesterday',
                              color: Color(0xFFB39DDB),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({
    required this.name,
    required this.subtitle,
    required this.level,
    required this.accent,
  });

  final String name;
  final String subtitle;
  final String level;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.medication_outlined,
              size: 20,
              color: Color(0xFF6E4A00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: const Color(0xFF2E2F42),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF7A7E8C),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF0D4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              level,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFFB76B00),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Color(0xFF8A8D99)),
        ],
      ),
    );
  }
}

class _RecentDispenseRow extends StatelessWidget {
  const _RecentDispenseRow({
    required this.initials,
    required this.name,
    required this.details,
    required this.time,
    required this.color,
  });

  final String initials;
  final String name;
  final String details;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              initials,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: const Color(0xFF2E2F42),
                    fontWeight: FontWeight.w700,
                   fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  details,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF7A7E8C),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF7A7E8C),
            ),
          ),
        ],
      ),
    );
  }
}
