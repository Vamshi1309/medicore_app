import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/lab_reports_provider.dart';
import 'package:frontend/features/patient/records/widgets/record_lab_report_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class LabReportsScreen extends ConsumerStatefulWidget {
  const LabReportsScreen({super.key});

  @override
  ConsumerState<LabReportsScreen> createState() => _LabReportsScreenState();
}

class _LabReportsScreenState extends ConsumerState<LabReportsScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(labReportsProvider, (prev, next) {
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
    final labReportsAsync = ref.watch(labReportsProvider);

    return labReportsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => Center(
        child: Text(
          error is ApiException ? error.message : "Something went wrong",
        ),
      ),

      data: (labReports) {
        if (labReports.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: LucideIcons.fileX,
              title: "No lab reports available",
              subtitle: "Your lab reports will appear here.",
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${labReports.length} reports available',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F7785),
                ),
              ),
            ),

            const SizedBox(height: 8),

            ...labReports.map(
              (item) => RecordlabReportCard(
                reportName: item.reportType,
                doctorName: item.radiologistName,
                date: formatDate(item.createdAt),
                notes: item.findings,
                onDownload: () {
                  //will added redirect link
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
}
