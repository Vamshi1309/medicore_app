import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend/features/labReports/data/models/lab_report_response.dart';
import 'package:frontend/features/labReports/providers/lab_reports_provider_annoted.dart';
import 'package:frontend/features/radiologist/common/radiologist_format.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RadiologistDashboard extends ConsumerWidget {
  const RadiologistDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final reportsAsync = ref.watch(myLabReportsProvider);
    final name = user?.name.trim().isNotEmpty == true
        ? user!.name.trim()
        : 'Radiologist';

    return Scaffold(
      backgroundColor: const Color(0xFFEAEFF9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF4D7CE8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Good morning',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                radiologistRoleLabel(user?.role.name),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.bell,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _SummaryCard(
                            value: reportsAsync.maybeWhen(
                              data: (reports) =>
                                  _countToday(reports).toString(),
                              orElse: () => '--',
                            ),
                            label: 'Uploaded today',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SummaryCard(
                            value: reportsAsync.maybeWhen(
                              data: (reports) =>
                                  _countThisMonth(reports).toString(),
                              orElse: () => '--',
                            ),
                            label: 'Total this month',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton.primary(
                      text: 'Upload new report',
                      onPressed: () => context.go(AppRoutes.radiologistUpload),
                      prefixIcon: LucideIcons.plus,
                      color: Colors.white,
                      foregroundColor: const Color(0xFF4D7CE8),
                      fontSize: 15,
                      isTextBold: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent reports',
                          style: TextStyle(
                            color: Color(0xFF1B1D30),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.radiologistReports),
                          child: const Text(
                            'View all',
                            style: TextStyle(
                              color: Color(0xFF4D7CE8),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    reportsAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (error, _) => _ReportsMessage(
                        message: error is ApiException
                            ? error.message
                            : 'Could not load reports',
                        onRetry: () => ref.invalidate(myLabReportsProvider),
                      ),
                      data: (reports) {
                        final recent = [...reports]
                          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
                        final visible = recent.take(3).toList();

                        if (visible.isEmpty) {
                          return const _ReportsMessage(
                            message: 'No reports uploaded yet',
                          );
                        }

                        return Column(
                          children: [
                            for (var i = 0; i < visible.length; i++) ...[
                              if (i > 0) const SizedBox(height: 12),
                              _ReportRow(
                                initials: radiologistInitials(
                                  visible[i].patientName,
                                ),
                                initialsColor: radiologistAvatarColors[
                                    i % radiologistAvatarColors.length],
                                name: visible[i].patientName,
                                date:
                                    '${radiologistReportTypeLabel(visible[i].reportType)} - ${formatRadiologistDate(visible[i].createdAt)}',
                                onTap: () =>
                                    context.go(AppRoutes.radiologistReports),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _countToday(List<LabReportResponse> reports) {
    final now = DateTime.now();
    return reports.where((report) {
      final created = report.createdAt.toLocal();
      return created.year == now.year &&
          created.month == now.month &&
          created.day == now.day;
    }).length;
  }

  int _countThisMonth(List<LabReportResponse> reports) {
    final now = DateTime.now();
    return reports.where((report) {
      final created = report.createdAt.toLocal();
      return created.year == now.year && created.month == now.month;
    }).length;
  }
}

class _SummaryCard extends StatelessWidget {
  final String value;
  final String label;

  const _SummaryCard({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ReportsMessage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7B8196),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 8),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String initials;
  final Color initialsColor;
  final String name;
  final String date;
  final VoidCallback onTap;

  const _ReportRow({
    required this.initials,
    required this.initialsColor,
    required this.name,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: initialsColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Color(0xFF4D7CE8),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Color(0xFF1F2430),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF7B8196),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                LucideIcons.chevronRight,
                color: Color(0xFF8A8F9D),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
