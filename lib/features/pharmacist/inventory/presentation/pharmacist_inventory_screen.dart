import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_text_styles.dart';

class PharmacistInventoryScreen extends StatefulWidget {
  const PharmacistInventoryScreen({super.key});

  @override
  State<PharmacistInventoryScreen> createState() => _PharmacistInventoryScreenState();
}

class _PharmacistInventoryScreenState extends State<PharmacistInventoryScreen> {
  String _selectedFilter = 'All';

  final List<_MedicineItem> _medicines = const [
    _MedicineItem(
      name: 'Amoxicillin 500mg',
      category: 'Antibiotic',
      expiry: 'Expires 18 Dec 2026',
      status: 'Low Stock',
      statusColor: Color(0xFFF9D7D7),
      statusTextColor: Color(0xFFB42318),
      stock: '8 units',
      price: '₹12',
      displayPrice: '₹12',
      iconBg: Color(0xFFEAF6FF),
      iconColor: Color(0xFF4A7DEB),
      type: 'low',
    ),
    _MedicineItem(
      name: 'Paracetamol 650mg',
      category: 'Analgesic',
      expiry: 'Expires 08 Mar 2027',
      status: 'In Stock',
      statusColor: Color(0xFFD8F5EA),
      statusTextColor: Color(0xFF067647),
      stock: '142 units',
      price: '₹5',
      displayPrice: '₹5',
      iconBg: Color(0xFFEAF6FF),
      iconColor: Color(0xFF4A7DEB),
      type: 'stock',
    ),
    _MedicineItem(
      name: 'Cetirizine 10mg',
      category: 'Antihistamine',
      expiry: 'Expires 12 Jan 2025',
      status: 'Expired',
      statusColor: Color(0xFFFDE8E8),
      statusTextColor: Color(0xFFB42318),
      stock: '0 units',
      price: '₹6',
      displayPrice: '₹6',
      iconBg: Color(0xFFEAF6FF),
      iconColor: Color(0xFF4A7DEB),
      type: 'expired',
    ),
    _MedicineItem(
      name: 'Metformin 500mg',
      category: 'Antidiabetic',
      expiry: 'Expires 24 Nov 2026',
      status: 'In Stock',
      statusColor: Color(0xFFD8F5EA),
      statusTextColor: Color(0xFF067647),
      stock: '84 units',
      price: '₹7',
      displayPrice: '₹7',
      iconBg: Color(0xFFEAF6FF),
      iconColor: Color(0xFF4A7DEB),
      type: 'stock',
    ),
    _MedicineItem(
      name: 'Azithromycin 500mg',
      category: 'Antibiotic',
      expiry: 'Expires 30 Aug 2026',
      status: 'Low Stock',
      statusColor: Color(0xFFF9D7D7),
      statusTextColor: Color(0xFFB42318),
      stock: '6 units',
      price: '₹24',
      displayPrice: '₹24',
      iconBg: Color(0xFFEAF6FF),
      iconColor: Color(0xFF4A7DEB),
      type: 'low',
    ),
  ];

  List<_MedicineItem> get _filteredMedicines {
    if (_selectedFilter == 'Low Stock') {
      return _medicines.where((m) => m.type == 'low').toList();
    }
    if (_selectedFilter == 'Expired') {
      return _medicines.where((m) => m.type == 'expired').toList();
    }
    return _medicines;
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredMedicines;

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
                        '${filteredList.length} medicines in stock',
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
                                  onTap: () => setState(() => _selectedFilter = 'All'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _FilterTab(
                                  label: 'Low Stock',
                                  selected: _selectedFilter == 'Low Stock',
                                  onTap: () => setState(() => _selectedFilter = 'Low Stock'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _FilterTab(
                                  label: 'Expired',
                                  selected: _selectedFilter == 'Expired',
                                  onTap: () => setState(() => _selectedFilter = 'Expired'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final medicine = filteredList[index];
                              return Container(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: const Color(0xFFE3E7EE)),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: medicine.iconBg,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.medication_rounded,
                                        color: medicine.iconColor,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            medicine.name,
                                            style: AppTextStyles.titleLarge.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF1D2432),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                medicine.category,
                                                style: AppTextStyles.bodyMedium.copyWith(
                                                  color: const Color(0xFF69778C),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 3,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: medicine.statusColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  medicine.status,
                                                  style: AppTextStyles.bodySmall.copyWith(
                                                    color: medicine.statusTextColor,
                                                    fontWeight: FontWeight.w700,
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
                                                medicine.expiry,
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: const Color(0xFF77839A),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                medicine.stock,
                                                style: AppTextStyles.bodySmall.copyWith(
                                                  color: const Color(0xFF536177),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          medicine.displayPrice,
                                          style: AppTextStyles.headlineMedium.copyWith(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF1B2636),
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          '/unit',
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: const Color(0xFF7C879C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (_, _) => const SizedBox(height: 10),
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

class _MedicineItem {
  final String name;
  final String category;
  final String expiry;
  final String status;
  final Color statusColor;
  final Color statusTextColor;
  final String stock;
  final String price;
  final String displayPrice;
  final Color iconBg;
  final Color iconColor;
  final String type;

  const _MedicineItem({
    required this.name,
    required this.category,
    required this.expiry,
    required this.status,
    required this.statusColor,
    required this.statusTextColor,
    required this.stock,
    required this.price,
    required this.displayPrice,
    required this.iconBg,
    required this.iconColor,
    required this.type,
  });
}