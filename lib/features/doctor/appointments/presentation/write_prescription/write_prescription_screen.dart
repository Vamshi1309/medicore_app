import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/patient/dashboard/data/models/medicine_frequency.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MedicineData {
  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  MedicineFrequency? frequency;
  final TextEditingController durationController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  void dispose() {
    medicineNameController.dispose();
    dosageController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}

class WritePrescriptionScreen extends StatefulWidget {
  const WritePrescriptionScreen({super.key});

  @override
  State<WritePrescriptionScreen> createState() =>
      _WritePrescriptionScreenState();
}

class _WritePrescriptionScreenState extends State<WritePrescriptionScreen> {
  final List<MedicineData> medicines = [MedicineData()];

  final TextEditingController doctorNotesController = TextEditingController();

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
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Patient information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _patientCard(),
            ),

            const SizedBox(height: 10),

            // Medicines heading
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Medicines",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                          Icon(LucideIcons.plus, color: Colors.white, size: 15),
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

            // Everything below is scrollable
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  // Medicine cards
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

                  // Doctor Notes
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

                  // Submit button
                  PrimaryButton.primary(
                    text: "Submit Prescription",
                    onPressed: () {},
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
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
                      medicines[index].dispose();
                      medicines.removeAt(index);
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

          _editTextRow(
            title: 'Medicine Name',
            controller: medicine.medicineNameController,
            hintText: 'e.g., Paracetamol',
          ),

          const SizedBox(height: 8),

          _editTextRow(
            title: 'Dosage',
            controller: medicine.dosageController,
            hintText: 'e.g., 500mg',
          ),

          const SizedBox(height: 8),

          _dropdownRow(
            title: "Frequency",
            value: null,
            onChanged: (MedicineFrequency? value) {},
          ),

          const SizedBox(height: 8),

          _editTextRow(
            title: 'Duration',
            controller: medicine.durationController,
            hintText: 'e.g., 5 days',
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

  @override
  void dispose() {
    for (final medicine in medicines) {
      medicine.dispose();
    }

    doctorNotesController.dispose();

    super.dispose();
  }
}
