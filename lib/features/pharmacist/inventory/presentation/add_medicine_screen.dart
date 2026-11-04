import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/features/inventory/data/models/add_medicine_request.dart';
import 'package:frontend/features/inventory/providers/add_medicine_provider.dart';
import 'package:frontend/features/inventory/providers/expired_medicine_provider.dart';
import 'package:frontend/features/inventory/providers/inventory_provider.dart';
import 'package:frontend/features/inventory/providers/low_stock_medicine_provider.dart';
import 'package:go_router/go_router.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicineNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _expiryDate;

  @override
  void dispose() {
    _medicineNameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );

    if (!mounted || selectedDate == null) {
      return;
    }

    setState(() {
      _expiryDate = selectedDate;
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _medicineNameController.text.trim();
    final quantityText = _quantityController.text.trim();
    final unit = _unitController.text.trim();
    final priceText = _priceController.text.trim();

    if (name.isEmpty) {
      AppSnackBar.error(context, 'Please enter medicine name');
      return;
    }

    final quantity = int.tryParse(quantityText);
    if (quantity == null || quantity <= 0) {
      AppSnackBar.error(context, 'Please enter a valid quantity');
      return;
    }

    if (unit.isEmpty) {
      AppSnackBar.error(context, 'Please enter a unit');
      return;
    }

    if (_expiryDate == null) {
      AppSnackBar.error(context, 'Please select an expiry date');
      return;
    }

    final price = double.tryParse(priceText);

    try {
      await ref.read(addMedicineProvider.notifier).addMedicine(
        AddMedicineRequest(
          medicineName: name,
          quantity: quantity,
          unit: unit,
          expiryDate: _expiryDate!.toIso8601String(),
          price: price,
        ),
      );

      if (!mounted) return;

      ref.invalidate(inventoryNotifierProvider);
      ref.invalidate(lowStockMedicinesProvider);
      ref.invalidate(expiredMedicinesProvider);

      AppSnackBar.success(context, 'Medicine added successfully');
      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, 'Unable to add medicine');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addMedicineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add medicine'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medicine details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _medicineNameController,
                  decoration: const InputDecoration(
                    labelText: 'Medicine name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medication_rounded),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                          ? 'Please enter medicine name'
                          : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.format_list_numbered),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter quantity';
                          }
                          if (int.tryParse(value.trim()) == null ||
                              int.parse(value.trim()) <= 0) {
                            return 'Please enter a valid quantity';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please enter unit'
                                : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickExpiryDate,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _expiryDate == null
                                ? 'Select expiry date'
                                : '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Price per unit (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                if (addState.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (addState.hasError)
                  ErrorState(
                    title: 'Unable to add medicine',
                    subtitle: addState.error.toString(),
                    onRetry: () => _submitForm(),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Add medicine'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
