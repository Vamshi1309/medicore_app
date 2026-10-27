import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_text_styles.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/inventory/providers/low_stock_medicine_provider.dart';
import 'package:frontend/features/pharmacy/providers/pharmacist_dispence_history_provider.dart';
import 'package:frontend/features/prescription/providers/all_prescription_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PharmacistDashboard extends ConsumerWidget {
  const PharmacistDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    final prescriptions = ref.watch(getAllPrescriptionsProvider);
    final totalPrescriptions = prescriptions.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    final dispenseHistory = ref.watch(pharmacistDispenceHistoryProvider);
    final totalDispenced = dispenseHistory.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

    final lowStockMedicines = ref.watch(lowStockMedicinesProvider);
    final totalLowStock = lowStockMedicines.maybeWhen(
      data: (list) => list.length,
      orElse: () => 0,
    );

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
                                'Hello, ${user?.name}',
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
                          child: _MetricCard(
                            value: totalPrescriptions.toString(),
                            label: 'Prescriptions',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(
                            value: totalLowStock.toString(),
                            label: 'Low stock',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _MetricCard(
                            value: totalDispenced.toString(),
                            label: 'Dispensed',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          context.go(AppRoutes.pharmacistPrescriptions);
                        },
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
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: SingleChildScrollView(
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
                        lowStockMedicines.when(
                          data: (list) {
                            if (list.isEmpty) {
                              return EmptyState(
                                icon: LucideIcons.clipboard,
                                title: "Empty List",
                                subtitle: "No Low Stock Medicines",
                              );
                            }

                            return ListView.builder(
                              itemBuilder: (context, index) {
                                final medicine = list[index];

                                return _AlertRow(
                                  name: medicine.medicineName,
                                  subtitle:
                                      "Only ${medicine.quantity} units remaining",
                                  level: "Low",
                                  accent: Colors.orangeAccent,
                                );
                              },
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => ErrorState(
                            title: "Error",
                            subtitle: error.toString(),
                          ),
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
                        dispenseHistory.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) => ErrorState(
                            title: "Error",
                            subtitle: error.toString(),
                          ),
                          data: (list) {
                            if (list.isEmpty) {
                              return const EmptyState(
                                icon: LucideIcons.fileText,
                                title: "Empty",
                                subtitle: "No prescriptions Found.",
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final prescription = list[index];
                                return _RecentDispenseRow(
                                  initials: getInitials(
                                    prescription.patientName,
                                  ),
                                  name: prescription.patientName,
                                  details:
                                      '${prescription.items.length} medicine${prescription.items.length == 1 ? '' : 's'}',
                                  time:
                                      '${formatDispenseDate(prescription.dispensedAt)}\n${formatDispenseTime(prescription.dispensedAt)}',
                                  color: Colors.lightBlueAccent,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
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
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
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

String getInitials(String name) {
  final cleanName = name.trim();

  if (cleanName.isEmpty) {
    return '';
  }

  final parts = cleanName.split(RegExp(r'\s+'));

  if (parts.length == 1) {
    return parts.first[0].toUpperCase();
  }

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}

String formatDispenseDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String formatDispenseTime(DateTime date) {
  final hour = date.hour;
  final minute = date.minute;
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;

  return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
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
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF7A7E8C),
            ),
          ),
        ],
      ),
    );
  }
}
