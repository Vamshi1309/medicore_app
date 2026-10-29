import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/pharmacist/dashboard/presentation/pharmacist_dashboard.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_item_request.dart';
import 'package:frontend/features/pharmacy/data/models/dispense_medicine_request.dart';
import 'package:frontend/features/pharmacy/providers/dispense_medicine_provider.dart';
import 'package:frontend/features/pharmacy/providers/pharmacist_dispence_history_provider.dart';
import 'package:frontend/features/prescription/data/models/enums/dispence_status.dart';
import 'package:frontend/features/prescription/data/models/prescription_item_response.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/providers/all_prescription_provider.dart';
import 'package:frontend/features/prescription/providers/prescription_by_id_provider.dart';

class PharmacistDispenceScreen extends ConsumerStatefulWidget {
  final String prescriptionId;
  const PharmacistDispenceScreen({super.key, required this.prescriptionId});

  @override
  ConsumerState<PharmacistDispenceScreen> createState() =>
      _PharmacistDispenceScreenState();
}

class _PharmacistDispenceScreenState
    extends ConsumerState<PharmacistDispenceScreen> {
  final Map<String, int> _quantities = {};

  @override
  void initState() {
    super.initState();
  }

  double totalAmount(List<PrescriptionItemResponse> items) {
    return items.fold<double>(
      0.0,
      (sum, item) =>
          sum + (_quantities[item.itemId] ?? item.quantity) * item.pricePerUnit,
    );
  }

  bool _isCompleted = false;

  void _updateQuantity(int index, int delta, PrescriptionItemResponse item) {
    final currentQuantity = _quantities[item.itemId] ?? item.quantity;
    final nextQuantity = (currentQuantity + delta).clamp(0, 99);

    setState(() {
      _quantities[item.itemId] = nextQuantity;
    });
  }

  String formatPrescriptionId(String id) {
    return 'RX-${id.substring(0, 4).toUpperCase()}';
  }

  Future<void> _confirmDispense(PrescriptionResponse prescription) async {
    try {
      final request = DispenseMedicineRequest(
        prescriptionId: prescription.prescriptionId,
        items: prescription.items.map((item) {
          final medicineId = item.medicineId;

          if (medicineId == null) {
            throw ApiException(
              message:
                  'Medicine ID is missing for ${item.medicineName ?? 'an item'}.',
            );
          }

          return DispenseItemRequest(
            medicineId: medicineId,
            quantityDispensed: _quantities[item.itemId] ?? item.quantity,
          );
        }).toList(),
      );

      await ref
          .read(dispenseMedicineProvider.notifier)
          .dispenseMedicine(request);

      if (!mounted) return;

      setState(() {
        _isCompleted = true;
      });

      ref.invalidate(pharmacistDispenceHistoryProvider);
      ref.invalidate(getAllPrescriptionsProvider);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void _backToHome() {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildReviewScreen(PrescriptionResponse prescription) {
    final isDispensing = ref.watch(dispenseMedicineProvider).isLoading;
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
                        Text(
                          '${formatPrescriptionId(prescription.prescriptionId)} • Before dispensing',
                          style: const TextStyle(
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
                  StatusBadge(
                    status: "Pending",
                    backgroundColor: Colors.white24,
                    textColor: Colors.white,
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
                            child: Text(
                              getInitials(prescription.patientName),
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
                              children: [
                                Text(
                                  prescription.patientName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Prescribed by Dr. ${prescription.doctorName}',
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
                    ...List.generate(prescription.items.length, (index) {
                      final item = prescription.items[index];
                      String idx = (index + 1).toString();
                      final quantity =
                          _quantities[item.itemId] ?? item.quantity;
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
                                      idx,
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
                                      item.medicineName!,
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
                                      "Take Medicine at ${item.frequency.name}",
                                      style: const TextStyle(
                                        color: Color(0xFF667A8E),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Duration : ${item.durationInDays} Days",
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
                                              _updateQuantity(index, -1, item),
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
                                            '$quantity',
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
                                              _updateQuantity(index, 1, item),
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
                                    '₹${(quantity * item.pricePerUnit).toStringAsFixed(2)}',
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
                          for (var item in prescription.items)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.medicineName} × ${_quantities[item.itemId] ?? item.quantity}',
                                      style: const TextStyle(
                                        color: Color(0xFF2A3C4B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${((_quantities[item.itemId] ?? item.quantity) * item.pricePerUnit).toStringAsFixed(2)}',
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
                                '₹${totalAmount(prescription.items)}',
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
                      text: isDispensing
                          ? 'Dispensing...'
                          : 'Confirm Dispense & Update Stock',
                      onPressed: isDispensing
                          ? null
                          : () => _confirmDispense(prescription),
                      color: const Color(0xFF1D8CE5),
                      fontSize: 18,
                      prefixIcon: isDispensing
                          ? null
                          : Icons.check_circle_rounded,
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

  Widget _buildCompletedScreen(PrescriptionResponse prescription) {
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
                        Text(
                          '${formatPrescriptionId(prescription.prescriptionId)} • Successfully recorded',
                          style: const TextStyle(
                            color: Color(0xD9EAFBFF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
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
                  StatusBadge(
                    status: "Completed",
                    backgroundColor: Colors.white24,
                    textColor: Colors.white,
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
                                child: Text(
                                  getInitials(prescription.patientName),
                                  style: const TextStyle(
                                    color: Color(0xFF0B5EA5),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  prescription.patientName,
                                  style: const TextStyle(
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
                          _buildDetailRow(
                            'Prescription',
                            formatPrescriptionId(prescription.prescriptionId),
                          ),
                          _buildDetailRow(
                            'Medicines issued',
                            '${prescription.items.length}',
                          ),
                          _buildDetailRow(
                            'Amount collected',
                            '₹${totalAmount(prescription.items).toStringAsFixed(2)}',
                          ),
                          _buildDetailRow(
                            'Status',
                            'Dispense completed',
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
                            children: [
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
                                formatPrescriptionId(
                                  prescription.prescriptionId,
                                ),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF566D7E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...prescription.items.map((item) {
                            final quantity =
                                _quantities[item.itemId] ?? item.quantity;
                            final amount = quantity * item.pricePerUnit;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.medicineName ?? 'Unknown medicine'} • '
                                      '$quantity item${quantity == 1 ? '' : 's'}',
                                      style: const TextStyle(
                                        color: Color(0xFF2A3C4B),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF2A3C4B),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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
                                '₹${totalAmount(prescription.items)}',
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
                        children: [
                          const CircleAvatar(
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
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Hand over the medicines and dosage instructions to '
                              '${prescription.patientName}.',
                              style: const TextStyle(
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
    final prescriptionAsync = ref.watch(
      prescriptionByIdProvider(widget.prescriptionId),
    );

    return prescriptionAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stackTrace) => Scaffold(
        body: Center(child: Text('Failed to load prescription: $error')),
      ),
      data: (prescription) {
        final isCompleted =
            _isCompleted || prescription.status == DispensingStatus.completed;

        return isCompleted
            ? _buildCompletedScreen(prescription)
            : _buildReviewScreen(prescription);
      },
    );
  }
}
