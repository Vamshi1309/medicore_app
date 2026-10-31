import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/theme/app_text_styles.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';
import 'package:frontend/features/inventory/providers/expired_medicine_provider.dart';
import 'package:frontend/features/inventory/providers/inventory_provider.dart';
import 'package:frontend/features/inventory/providers/low_stock_medicine_provider.dart';

class PharmacistInventoryScreen extends ConsumerStatefulWidget {
  const PharmacistInventoryScreen({super.key});

  @override
  ConsumerState<PharmacistInventoryScreen> createState() =>
      _PharmacistInventoryScreenState();
}

class _PharmacistInventoryScreenState
    extends ConsumerState<PharmacistInventoryScreen> {
  String _selectedFilter = 'All';

  List<MedicineResponse> _filterMedicines(
    String filter,
    List<MedicineResponse> medicines,
  ) {
    if (filter == 'Low Stock') {
      return medicines.where((medicine) => medicine.quantity <= 10).toList();
    }

    if (filter == 'Expired') {
      final now = DateTime.now();
      return medicines.where((medicine) => medicine.expiryDate.isBefore(now)).toList();
    }

    return medicines;
  }

  @override
  Widget build(BuildContext context) {
    final inventoryState = ref.watch(inventoryNotifierProvider);
    final lowStockState = ref.watch(lowStockMedicinesProvider);
    final expiredState = ref.watch(expiredMedicinesProvider);

    final allMedicines = inventoryState.maybeWhen(
      data: (list) => list,
      orElse: () => <MedicineResponse>[],
    );
    final lowStockMedicines = lowStockState.maybeWhen(
      data: (list) => list,
      orElse: () => <MedicineResponse>[],
    );
    final expiredMedicines = expiredState.maybeWhen(
      data: (list) => list,
      orElse: () => <MedicineResponse>[],
    );

    final currentMedicines = switch (_selectedFilter) {
      'Low Stock' => _filterMedicines('Low Stock', lowStockMedicines),
      'Expired' => _filterMedicines('Expired', expiredMedicines),
      _ => _filterMedicines('All', allMedicines),
    };

    final activeState = switch (_selectedFilter) {
      'Low Stock' => lowStockState,
      'Expired' => expiredState,
      _ => inventoryState,
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F6AEF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${currentMedicines.length} medicines in stock',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              'Inventory',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                    child: Column(
                      children: [
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE4E9F5)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: Color(0xFF7A869A),
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Search medicines',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: const Color(0xFF838FA5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 42,
                          child: Row(
                            children: [
                              Expanded(
                                child: _FilterTab(
                                  label: 'All',
                                  selected: _selectedFilter == 'All',
                                  onTap: () =>
                                      setState(() => _selectedFilter = 'All'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _FilterTab(
                                  label: 'Low Stock',
                                  selected: _selectedFilter == 'Low Stock',
                                  onTap: () => setState(
                                    () => _selectedFilter = 'Low Stock',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _FilterTab(
                                  label: 'Expired',
                                  selected: _selectedFilter == 'Expired',
                                  onTap: () => setState(
                                    () => _selectedFilter = 'Expired',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: activeState.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (error, stackTrace) => Center(
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  'Something went wrong while loading medicines.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: const Color(0xFF1D2432),
                                  ),
                                ),
                              ),
                            ),
                            data: (medicines) {
                              if (currentMedicines.isEmpty) {
                                return const Center(
                                  child: Text('No medicines found'),
                                );
                              }

                              return ListView.separated(
                                itemCount: currentMedicines.length,
                                itemBuilder: (context, index) {
                                  final medicine = currentMedicines[index];
                                  final isLowStock = medicine.quantity <= 10;
                                  final isExpired = medicine.expiryDate.isBefore(
                                    DateTime.now(),
                                  );
                                  final statusLabel =
                                      isExpired ? 'Expired' : (isLowStock ? 'Low Stock' : 'In Stock');
                                  final statusColor = isExpired || isLowStock
                                      ? const Color(0xFFFDE8E8)
                                      : const Color(0xFFD8F5EA);
                                  final statusTextColor = isExpired || isLowStock
                                      ? const Color(0xFFB42318)
                                      : const Color(0xFF067647);

                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      12,
                                      12,
                                      12,
                                      10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: const Color(0xFFE3E7EE),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEAF6FF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.medication_rounded,
                                            color: Color(0xFF4A7DEB),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                medicine.medicineName,
                                                style: AppTextStyles.titleLarge
                                                    .copyWith(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w700,
                                                      color: const Color(
                                                        0xFF1D2432,
                                                      ),
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    medicine.unit,
                                                    style: AppTextStyles.bodyMedium
                                                        .copyWith(
                                                          color: const Color(
                                                            0xFF69778C,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: statusColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      statusLabel,
                                                      style: AppTextStyles.bodySmall
                                                          .copyWith(
                                                            color: statusTextColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 11,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    'Expires ${medicine.expiryDate.day}/${medicine.expiryDate.month}/${medicine.expiryDate.year}',
                                                    style: AppTextStyles.bodySmall
                                                        .copyWith(
                                                          color: const Color(
                                                            0xFF77839A,
                                                          ),
                                                        ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    '${medicine.quantity} units',
                                                    style: AppTextStyles.bodySmall
                                                        .copyWith(
                                                          color: const Color(
                                                            0xFF536177,
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '₹${medicine.price.toStringAsFixed(0)}',
                                              style: AppTextStyles.headlineMedium
                                                  .copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF1B2636,
                                                    ),
                                                  ),
                                            ),
                                            const SizedBox(height: 1),
                                            Text(
                                              '/unit',
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    color: const Color(
                                                      0xFF7C879C,
                                                    ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAF2FF) : const Color(0xFFF1F3F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFFD8E4FF) : const Color(0xFFE1E6ED),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFFB7C8F9).withValues(alpha: 0.18),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: selected ? const Color(0xFF1E49B9) : const Color(0xFF5C6E86),
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
