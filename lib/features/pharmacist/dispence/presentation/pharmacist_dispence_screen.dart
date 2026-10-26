import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/primary_button.dart';

class PharmacistDispenceScreen extends StatefulWidget {
  const PharmacistDispenceScreen({super.key});

  @override
  State<PharmacistDispenceScreen> createState() =>
      _PharmacistDispenceScreenState();
}

class _PharmacistDispenceScreenState extends State<PharmacistDispenceScreen> {
  late List<_MedicineItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      const _MedicineItem(
        number: '1',
        name: 'Metformin 500mg',
        schedule: '1 tablet • 2x daily',
        duration: '30 days',
        quantity: 1,
        unitPrice: 7,
      ),
      const _MedicineItem(
        number: '2',
        name: 'Atorvastatin 10mg',
        schedule: '1 tablet • at night',
        duration: '30 days',
        quantity: 2,
        unitPrice: 11,
      ),
    ];
  }

  int get totalAmount {
    return _items.fold<int>(
      0,
      (sum, item) => sum + item.quantity * item.unitPrice,
    );
  }

  bool _isCompleted = false;

  void _updateQuantity(int index, int delta) {
    setState(() {
      final next = _items[index].quantity + delta;
      _items[index] = _items[index].copyWith(quantity: next.clamp(0, 99));
    });
  }

  void _confirmDispense() {
    setState(() {
      _isCompleted = true;
    });
  }

  void _backToHome() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildReviewScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 18, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF1B8FE8), Color(0xFF1A7FE2)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RX-2083 • Before dispensing',
                          style: TextStyle(
                            color: Color(0xD9EAFBFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Review & Dispense',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8BF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(
                            Icons.warning_rounded,
                            color: Color(0xFFB9871A),
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Before dispensing',
                                  style: TextStyle(
                                    color: Color(0xFF645221),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Verify the patient, check each medicine, and enter the quantity you are handing over.',
                                  style: TextStyle(
                                    color: Color(0xFF72613D),
                                    fontSize: 14,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF20A3EE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFBBE4FF),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'MP',
                              style: TextStyle(
                                color: Color(0xFF0B5EA5),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Meera Patel',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Age 42 • Prescribed by Dr. Vikram Singh',
                                  style: TextStyle(
                                    color: Color(0xFFE6F6FF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '1. Check medicines & quantity',
                      style: TextStyle(
                        color: Color(0xFF1C2C3D),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...List.generate(_items.length, (index) {
                      final item = _items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFB9E7FF),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.number,
                                      style: const TextStyle(
                                        color: Color(0xFF0B5EA5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Color(0xFF1B2D3C),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.schedule,
                                      style: const TextStyle(
                                        color: Color(0xFF667A8E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.duration,
                                      style: const TextStyle(
                                        color: Color(0xFF667A8E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text(
                                    'Quantity',
                                    style: TextStyle(
                                      color: Color(0xFF29415D),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFFD8E1EB),
                                        width: 1.2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () =>
                                              _updateQuantity(index, -1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.remove,
                                              size: 16,
                                              color: Color(0xFF1E2C3A),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 34,
                                          child: Text(
                                            '${item.quantity}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFF1E2C3A),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () =>
                                              _updateQuantity(index, 1),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(
                                              Icons.add,
                                              size: 16,
                                              color: Color(0xFF1E2C3A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '₹${item.quantity * item.unitPrice}',
                                    style: const TextStyle(
                                      color: Color(0xFF1B2D3C),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 22),
                    const Text(
                      '2. Review payment',
                      style: TextStyle(
                        color: Color(0xFF1C2C3D),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (var item in _items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.name} × ${item.quantity}',
                                      style: const TextStyle(
                                        color: Color(0xFF2A3C4B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${item.quantity * item.unitPrice}',
                                    style: const TextStyle(
                                      color: Color(0xFF2A3C4B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const Divider(
                            height: 24,
                            thickness: 1.2,
                            color: Color(0xFFE7EDF4),
                          ),
                          Row(
                            children: [
                              const Text(
                                'Grand total',
                                style: TextStyle(
                                  color: Color(0xFF1B2D3C),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '₹$totalAmount',
                                style: const TextStyle(
                                  color: Color(0xFF1D7FCE),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton.primary(
                      text: 'Confirm Dispense & Update Stock',
                      onPressed: _confirmDispense,
                      color: const Color(0xFF1D8CE5),
                      fontSize: 18,
                      prefixIcon: Icons.check_circle_rounded,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Only confirm after medicines have been packed and payment is collected.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF667B91),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 18, 18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF1B8FE8), Color(0xFF1A7FE2)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'RX-2083 • Successfully recorded',
                          style: TextStyle(
                            color: Color(0xD9EAFBFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Dispense Complete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1F4EA),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Column(
                          children: const [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: Color(0xFF2CC48D),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Medicines dispensed',
                              style: TextStyle(
                                color: Color(0xFF1C2C3D),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'The inventory has been updated and this prescription is now marked as completed.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF566D7E),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB9E7FF),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'MP',
                                  style: TextStyle(
                                    color: Color(0xFF0B5EA5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Meera Patel',
                                  style: TextStyle(
                                    color: Color(0xFF1F2D3D),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(color: Color(0xFFE6EDF4), thickness: 1),
                          const SizedBox(height: 12),
                          _buildDetailRow('Prescription', 'RX-2083'),
                          _buildDetailRow('Medicines issued', '2'),
                          _buildDetailRow('Amount collected', '₹18'),
                          _buildDetailRow(
                            'Status',
                            'Paid & completed',
                            isStatus: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(
                                child: Text(
                                  'Bill summary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2D3D),
                                  ),
                                ),
                              ),
                              Text(
                                'RX-2083',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF566D7E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.name} • ${item.quantity} item${item.quantity > 1 ? 's' : ''}',
                                      style: const TextStyle(
                                        color: Color(0xFF2A3C4B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${item.quantity * item.unitPrice}',
                                    style: const TextStyle(
                                      color: Color(0xFF2A3C4B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            height: 24,
                            thickness: 1.2,
                            color: Color(0xFFE7EDF4),
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total paid',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1F2D3D),
                                  ),
                                ),
                              ),
                              Text(
                                '₹$totalAmount',
                                style: const TextStyle(
                                  color: Color(0xFF1D7FCE),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F1FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFF4E8EF7),
                            child: Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hand over the medicines and dosage instructions to Meera.',
                              style: TextStyle(
                                color: Color(0xFF2F4D66),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton.primary(
                      text: 'Dispense Next Prescription',
                      onPressed: _backToHome,
                      color: const Color(0xFF1D8CE5),
                      fontSize: 18,
                      suffixIcon: Icons.arrow_forward,
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: _backToHome,
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF1D8CE5),
                      ),
                      icon: const Icon(Icons.home_outlined),
                      label: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF53677B),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFD9F5EA),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1A8D5C),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF1F2D3D),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isCompleted ? _buildCompletedScreen() : _buildReviewScreen();
  }
}

class _MedicineItem {
  final String number;
  final String name;
  final String schedule;
  final String duration;
  final int quantity;
  final int unitPrice;

  const _MedicineItem({
    required this.number,
    required this.name,
    required this.schedule,
    required this.duration,
    required this.quantity,
    required this.unitPrice,
  });

  _MedicineItem copyWith({int? quantity}) {
    return _MedicineItem(
      number: number,
      name: name,
      schedule: schedule,
      duration: duration,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice,
    );
  }
}
