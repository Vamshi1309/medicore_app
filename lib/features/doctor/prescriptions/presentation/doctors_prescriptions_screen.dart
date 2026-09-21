import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/features/doctor/prescriptions/widgets/doctor_prescription_card.dart';
import 'package:frontend/features/doctor/widgets/doctor_header.dart';
import 'package:frontend/features/prescription/providers/prescription_provider.dart';

class DoctorsPrescriptionScreen extends ConsumerStatefulWidget {
  const DoctorsPrescriptionScreen({super.key});

  @override
  ConsumerState<DoctorsPrescriptionScreen> createState() =>
      _DoctorsAppointmentsScreenState();
}

class _DoctorsAppointmentsScreenState
    extends ConsumerState<DoctorsPrescriptionScreen> {
      int prescriptionCount = 0;
  @override
  void initState() {
    super.initState();

    Future.microtask((){
      ref.read(prescriptionProvider.notifier).getPrescriptionByDoctorId();
    });

    ref.listenManual(prescriptionProvider, (prev, next) {
      if (!mounted) return;

      next.whenOrNull(
        error: (err, _) {
          final message = err is ApiException
              ? err.message
              : "Something went wrong";

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncPrescription = ref.watch(prescriptionProvider);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DoctorHeader(
              header: "Prescriptions",
              subHeader: "$prescriptionCount total prescriptions written",
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: asyncPrescription.when(
                  loading: () {
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stackTrace) {
                    return ErrorState(
                      title: "Error",
                      subtitle: error is ApiException
                          ? error.message
                          : "Please try again",
                    );
                  },
                  data: (prescriptions) {
                    if (prescriptions.isEmpty) {
                      return const Center(
                        child: Text("No prescriptions found"),
                      );
                    }

                    return ListView.builder(
                      itemCount: prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = prescriptions[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: DoctorsPrescriptionCard(
                            patientName: prescription.patientName,
                            reason: prescription.notes ?? "",
                            date: _formatDate(prescription.createdAt),
                            medicineCount: prescription.items.length,
                            onDownload: () {
                              // Download PDF
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

