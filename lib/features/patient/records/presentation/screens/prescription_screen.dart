import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/prescription_provider.dart';
import 'package:frontend/features/patient/records/widgets/record_prescription_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PrescriptionsScreen extends ConsumerStatefulWidget {
  const PrescriptionsScreen({super.key});

  @override
  ConsumerState<PrescriptionsScreen> createState() =>
      _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends ConsumerState<PrescriptionsScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(prescriptionProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : "Something went wrong";

          AppSnackBar.error(context, message);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionAsync = ref.watch(prescriptionProvider);

    return prescriptionAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => Center(
        child: Text(
          error is ApiException ? error.message : "Something went wrong",
        ),
      ),

      data: (prescriptions) {
        if (prescriptions.isEmpty) {
          return const Center(child: EmptyState(
            icon: LucideIcons.fileX, 
            title: "No prescriptions available", 
            subtitle: "Your prescriptions will appear here.")
            );
        }

        return ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${prescriptions.length} prescriptions available',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F7785),
                ),
              ),
            ),

            const SizedBox(height: 8),

            ...prescriptions.map(
              (item) => RecordPrescriptionCard(
                doctorName: item.doctorName,
                specialty: item.doctorSpecialization,
                date: formatDate(item.createdAt),
                medicineCount: item.items.length,
                onDownload: () {
                  downloadAndOpenPrescription(item.prescriptionId);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year}';
  }

  Future<void> downloadAndOpenPrescription(String prescriptionId) async {
    try {
      final pdfBytes = await ref
          .read(prescriptionProvider.notifier)
          .downloadPrescriptionPdf(prescriptionId);

      final directory = await getTemporaryDirectory();

      final file = File('${directory.path}/prescription_$prescriptionId.pdf');

      await file.writeAsBytes(pdfBytes);

      await OpenFilex.open(file.path);
    } catch (e) {
      if (!mounted) return;

      final message = e is ApiException
          ? e.message
          : "Failed to open prescription";

      AppSnackBar.error(context, message);
    }
  }
}
