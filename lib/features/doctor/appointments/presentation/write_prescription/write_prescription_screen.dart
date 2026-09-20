import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/inventory/data/models/medicine_response.dart';
import 'package:frontend/features/inventory/providers/inventory_provider.dart';
import 'package:frontend/features/prescription/data/models/create_prescription_request.dart';
import 'package:frontend/features/prescription/data/models/medicine_frequency.dart';
import 'package:frontend/features/prescription/data/models/prescription_item_request.dart';
import 'package:frontend/features/prescription/data/models/prescription_response.dart';
import 'package:frontend/features/prescription/data/models/update_prescription_request.dart';
import 'package:frontend/features/prescription/providers/prescription_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MedicineData {
  String? medicineId;
  String medicineName = '';

  final TextEditingController dosageController = TextEditingController();

  MedicineFrequency? frequency;

  final TextEditingController durationController = TextEditingController();

  final TextEditingController instructionsController = TextEditingController();

  void dispose() {
    dosageController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}

class WritePrescriptionScreen extends ConsumerStatefulWidget {
  final String appointmentId;

  const WritePrescriptionScreen({super.key, required this.appointmentId});

  @override
  ConsumerState<WritePrescriptionScreen> createState() =>
      _WritePrescriptionScreenState();
}

class _WritePrescriptionScreenState
    extends ConsumerState<WritePrescriptionScreen> {
  final List<MedicineData> medicines = [MedicineData()];

  final TextEditingController doctorNotesController = TextEditingController();

  String? prescriptionId;

  bool isLoadingPrescription = true;
  bool isLoadingMedicines = true;

  List<MedicineResponse> medicinesList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrescription();
      _loadMedicinesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Write Prescription",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: isLoadingPrescription
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: _patientCard(),
                  ),

                  const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Medicines",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              medicines.add(MedicineData());
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  LucideIcons.plus,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  "Add Medicines",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        ...List.generate(
                          medicines.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _addMedicineCard(
                              index: index,
                              medicine: medicines[index],
                            ),
                          ),
                        ),

                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Doctor Notes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 10),
                              AppTextField(
                                controller: doctorNotesController,
                                maxLines: 4,
                                hintText:
                                    "Additional instruction, diet, follow up....",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        PrimaryButton.primary(
                          text: "Submit Prescription",
                          onPressed: _submitPrescription,
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _patientCard() {
    return AppCard(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Text(
              "VD",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Uday Kummar",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 3),
              Text("Patient", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdownRow({
    required String title,
    required MedicineFrequency? value,
    required ValueChanged<MedicineFrequency?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<MedicineFrequency>(
            initialValue: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            hint: const Text(
              "Select frequency",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            items: MedicineFrequency.values.map((frequency) {
              return DropdownMenuItem<MedicineFrequency>(
                value: frequency,
                child: Text(
                  frequency.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _addMedicineCard({
    required int index,
    required MedicineData medicine,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Medicine ${index + 1}",
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (medicines.length > 1)
                IconButton(
                  onPressed: () {
                    setState(() {
                      medicine.dispose();
                      medicines.remove(medicine);
                    });
                  },
                  icon: const Icon(
                    LucideIcons.trash2,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          _medicineAutocomplete(medicine: medicine),

          const SizedBox(height: 8),

          _editTextRow(
            title: 'Dosage',
            controller: medicine.dosageController,
            hintText: 'e.g., 500mg',
          ),

          const SizedBox(height: 8),

          _dropdownRow(
            title: "Frequency",
            value: medicine.frequency,
            onChanged: (MedicineFrequency? value) {
              setState(() {
                medicine.frequency = value;
              });
            },
          ),

          const SizedBox(height: 8),

          _editTextRow(
            title: 'Duration',
            controller: medicine.durationController,
            hintText: 'e.g., 5',
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 8),

          _editTextRow(
            title: 'Instructions',
            controller: medicine.instructionsController,
            hintText: 'e.g., Take before breakfast',
          ),
        ],
      ),
    );
  }

  Widget _medicineAutocomplete({required MedicineData medicine}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Medicine Name",
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),

        const SizedBox(height: 5),

        Autocomplete<MedicineResponse>(
          key: ObjectKey(medicine),

          displayStringForOption: (medicine) {
            return medicine.medicineName;
          },

          initialValue: TextEditingValue(text: medicine.medicineName),

          optionsBuilder: (TextEditingValue textEditingValue) {
            final query = textEditingValue.text.trim().toLowerCase();

            if (query.isEmpty) {
              return medicinesList;
            }

            return medicinesList.where((medicine) {
              return medicine.medicineName.toLowerCase().contains(query);
            });
          },

          onSelected: (MedicineResponse selectedMedicine) {
            setState(() {
              medicine.medicineId = selectedMedicine.id;
              medicine.medicineName = selectedMedicine.medicineName;
            });
          },

          fieldViewBuilder:
              (
                BuildContext context,
                TextEditingController controller,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,

                  decoration: InputDecoration(
                    hintText: "Type medicine name",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  onChanged: (value) {
                    /*
               * Store the current text.
               */
                    medicine.medicineName = value;

                    /*
               * If the doctor changes the text after
               * selecting a medicine, the previous ID
               * should no longer be trusted.
               */
                    final selectedMedicine = medicinesList
                        .where(
                          (item) =>
                              item.id == medicine.medicineId &&
                              item.medicineName == value,
                        )
                        .firstOrNull;

                    if (selectedMedicine == null) {
                      medicine.medicineId = null;
                    }
                  },
                );
              },

          optionsViewBuilder:
              (
                BuildContext context,
                AutocompleteOnSelected<MedicineResponse> onSelected,
                Iterable<MedicineResponse> options,
              ) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 250,
                        maxWidth: 500,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final medicine = options.elementAt(index);

                          return ListTile(
                            dense: true,

                            title: Text(
                              medicine.medicineName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              "Available: ${medicine.quantity} ${medicine.unit}",
                              style: const TextStyle(fontSize: 11),
                            ),

                            onTap: () {
                              onSelected(medicine);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
        ),
      ],
    );
  }

  Widget _editTextRow({
    required String title,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? hintText,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 40,
          child: AppTextField(
            controller: controller,
            hintText: hintText,
            keyboardType: keyboardType ?? TextInputType.text,
            readOnly: readOnly,
            suffixIcon: suffixIcon,
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Future<void> _loadMedicinesList() async {
    try {
      final medicines = await ref
          .read(inventoryNotifierProvider.notifier)
          .getAllMedicines();

      if (!mounted) return;

      setState(() {
        medicinesList = medicines;
        isLoadingMedicines = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingMedicines = false;
      });

      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingMedicines = false;
      });

      AppSnackBar.error(context, "Failed to load medicines");
    }
  }

  Future<void> _loadPrescription() async {
    try {
      final prescription = await ref
          .read(prescriptionProvider.notifier)
          .getPrescriptionByAppointmentId(widget.appointmentId);

      if (!mounted) return;

      prescriptionId = prescription.prescriptionId;

      _loadPrescriptionIntoForm(prescription);

      setState(() {
        isLoadingPrescription = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      if (e.statusCode == 404) {
        setState(() {
          prescriptionId = null;
          isLoadingPrescription = false;
        });

        return;
      }

      setState(() {
        isLoadingPrescription = false;
      });

      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoadingPrescription = false;
      });

      AppSnackBar.error(context, "Failed to load prescription");
    }
  }

  void _loadPrescriptionIntoForm(PrescriptionResponse prescription) {
    doctorNotesController.text = prescription.notes ?? '';

    /*
     * Dispose the initially-created empty medicine
     * before replacing the list.
     */
    for (final medicine in medicines) {
      medicine.dispose();
    }

    medicines.clear();

    for (final item in prescription.items) {
      final medicine = MedicineData();

      /*
       * IMPORTANT:
       *
       * The prescription response already contains
       * medicineId AND medicineName.
       *
       * So we don't need to search the inventory list
       * to find the ID.
       */
      medicine.medicineId = item.medicineId;
      medicine.medicineName = item.medicineName ?? '';

      medicine.dosageController.text = item.dosage;

      medicine.durationController.text = item.durationInDays.toString();

      medicine.instructionsController.text = item.instructions ?? '';

      medicine.frequency = item.frequency;

      medicines.add(medicine);
    }

    if (medicines.isEmpty) {
      medicines.add(MedicineData());
    }
  }

  Future<void> _submitPrescription() async {
    if (medicines.isEmpty) {
      AppSnackBar.error(context, "Please add at least one medicine");
      return;
    }

    /*
     * Validate every medicine before making
     * the API request.
     */
    for (final medicine in medicines) {
      if (medicine.medicineId == null) {
        AppSnackBar.error(context, "Please select a medicine from the list");
        return;
      }

      if (medicine.medicineName.trim().isEmpty) {
        AppSnackBar.error(context, "Please select medicine name");
        return;
      }

      if (medicine.dosageController.text.trim().isEmpty) {
        AppSnackBar.error(context, "Please enter dosage");
        return;
      }

      if (medicine.durationController.text.trim().isEmpty) {
        AppSnackBar.error(context, "Please enter duration");
        return;
      }

      if (medicine.frequency == null) {
        AppSnackBar.error(context, "Please select medicine frequency");
        return;
      }

      if (int.tryParse(medicine.durationController.text.trim()) == null) {
        AppSnackBar.error(context, "Duration must be a valid number");
        return;
      }
    }

    try {
      final items = medicines.map((medicine) {
        return PrescriptionItemRequest(
          /*
           * Backend now expects medicineId.
           */
          medicineId: medicine.medicineId!,

          dosage: medicine.dosageController.text.trim(),

          durationDays: int.parse(medicine.durationController.text.trim()),

          frequency: medicine.frequency!,

          instructions: medicine.instructionsController.text.trim().isEmpty
              ? null
              : medicine.instructionsController.text.trim(),
        );
      }).toList();

      final notes = doctorNotesController.text.trim().isEmpty
          ? null
          : doctorNotesController.text.trim();

      final notifier = ref.read(prescriptionProvider.notifier);

      if (prescriptionId == null) {
        // CREATE
        final request = CreatePrescriptionRequest(
          appointmentId: widget.appointmentId,
          notes: notes,
          items: items,
        );

        await notifier.createPrescription(request);

        if (!mounted) return;

        AppSnackBar.success(context, "Prescription created successfully");
      } else {
        // UPDATE
        final request = UpdatePrescriptionRequest(notes: notes, items: items);

        await notifier.updatePrescription(request, prescriptionId!);

        if (!mounted) return;

        AppSnackBar.success(context, "Prescription updated successfully");
      }

      if (!mounted) return;

      context.pop();
    } on ApiException catch (e) {
      if (!mounted) return;

      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.error(
        context,
        prescriptionId == null
            ? "Failed to create prescription"
            : "Failed to update prescription",
      );
    }
  }

  @override
  void dispose() {
    for (final medicine in medicines) {
      medicine.dispose();
    }

    doctorNotesController.dispose();

    super.dispose();
  }
}
