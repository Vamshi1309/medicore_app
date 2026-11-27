import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/labReports/data/models/lab_report_response.dart';
import 'package:frontend/features/labReports/providers/lab_reports_provider_annoted.dart';
import 'package:frontend/features/labReports/providers/lab_reports_repository_provider.dart';
import 'package:frontend/features/radiologist/common/radiologist_format.dart';
import 'package:url_launcher/url_launcher.dart';

class RadiologistReportsScreen extends ConsumerStatefulWidget {
  const RadiologistReportsScreen({super.key});

  @override
  ConsumerState<RadiologistReportsScreen> createState() =>
      _RadiologistReportsScreenState();
}

class _RadiologistReportsScreenState
    extends ConsumerState<RadiologistReportsScreen> {
  static const _bg = Color(0xFFEAEFFA);
  static const _textDark = Color(0xFF1B1E2B);
  static const _textGrey = Color(0xFF6B7280);
  static const _border = Color(0xFFD7DFF2);

  static const _filters = ['All', ..._filterLabels];

  final _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'All';
  String? _openingReportId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<LabReportResponse> _filtered(List<LabReportResponse> reports) {
    final q = _query.trim().toLowerCase();
    final sorted = [...reports]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.where((report) {
      final matchesName =
          q.isEmpty || report.patientName.toLowerCase().contains(q);
      final matchesType =
          _selectedFilter == 'All' ||
          radiologistReportTypeLabel(report.reportType) == _selectedFilter;
      return matchesName && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(myLabReportsProvider);

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchField(),
                const SizedBox(height: 12),
                _buildFilterChips(),
                const SizedBox(height: 14),
                reportsAsync.maybeWhen(
                  data: (reports) {
                    final count = _filtered(reports).length;
                    return Text(
                      count == 1 ? '1 report' : '$count reports',
                      style: const TextStyle(
                        color: _textGrey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: reportsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _MessageState(
                message: error is ApiException
                    ? error.message
                    : 'Could not load reports',
                onRetry: () => ref.invalidate(myLabReportsProvider),
              ),
              data: (reports) {
                final items = _filtered(reports);
                if (reports.isEmpty) {
                  return const _MessageState(message: 'No reports uploaded yet');
                }
                if (items.isEmpty) return _buildEmptyState();

                return ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final report = items[index];
                    return _ReportCard(
                      report: report,
                      avatarColor: radiologistAvatarColors[
                          index % radiologistAvatarColors.length],
                      onTap: () => _showDetails(report, index),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 20,
        24,
        24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Reports you have uploaded',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: c, width: w),
    );

    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v),
      style: const TextStyle(fontSize: 14, color: _textDark),
      decoration: InputDecoration(
        hintText: 'Search by patient name',
        hintStyle: const TextStyle(color: _textGrey, fontSize: 16),
        prefixIcon: const Icon(Icons.search_rounded, color: _textGrey, size: 20),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, color: _textGrey, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: border(_border),
        enabledBorder: border(_border),
        focusedBorder: border(AppColors.primary, 1.5),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final f = _filters[index];
          return _FilterChip(
            label: f,
            selected: _selectedFilter == f,
            onTap: () => setState(() => _selectedFilter = f),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.description_outlined, size: 32, color: _textGrey),
            SizedBox(height: 6),
            Text(
              'No reports match your search',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textGrey, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openFile(String reportId) async {
    if (_openingReportId != null) return;
    setState(() => _openingReportId = reportId);
    try {
      final response = await ref
          .read(labReportsRepoProvider)
          .getDownloadUrl(reportId);
      if (response.data == null || response.data!.isEmpty) {
        throw ApiException(message: response.message);
      }

      final launched = await launchUrl(
        Uri.parse(response.data!),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        AppSnackBar.error(context, 'Unable to open the report');
      }
    } catch (error) {
      if (!mounted) return;
      AppSnackBar.error(
        context,
        error is ApiException ? error.message : 'Unable to open the report',
      );
    } finally {
      if (mounted) setState(() => _openingReportId = null);
    }
  }

  void _showDetails(LabReportResponse report, int index) {
    final fileName = radiologistFileName(report.reportUrl);
    final typeLabel = radiologistReportTypeLabel(report.reportType);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD7DFF2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _Avatar(
                    initials: radiologistInitials(report.patientName),
                    color: radiologistAvatarColors[
                        index % radiologistAvatarColors.length],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.patientName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textDark,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatRadiologistDate(report.createdAt),
                          style: const TextStyle(color: _textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  _typeBadge(typeLabel),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Findings',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                report.findings.trim().isEmpty
                    ? 'No findings were added.'
                    : report.findings,
                style: TextStyle(
                  color: report.findings.trim().isEmpty ? _textGrey : _textDark,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Attached file',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        radiologistFileIsPdf(fileName)
                            ? Icons.picture_as_pdf_outlined
                            : Icons.image_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        fileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton.primary(
                text: 'Open file',
                prefixIcon: Icons.open_in_new_rounded,
                isLoading: _openingReportId == report.reportId,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _openFile(report.reportId);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _filterLabels = [
  'X-Ray',
  'MRI',
  'CT Scan',
  'Blood Test',
  'Urine Test',
  'Ultrasound',
];

({Color bg, Color fg}) _typeColors(String type) {
  switch (type) {
    case 'MRI':
      return (bg: const Color(0xFFE8DDF3), fg: const Color(0xFF6A3FA0));
    case 'X-Ray':
      return (bg: const Color(0xFFDCE8FB), fg: AppColors.primary);
    case 'CT Scan':
      return (bg: const Color(0xFFF5E8BF), fg: const Color(0xFF8A6A00));
    case 'Blood Test':
      return (bg: const Color(0xFFFBE0DD), fg: const Color(0xFFC62828));
    case 'Urine Test':
      return (bg: const Color(0xFFFCEBCF), fg: const Color(0xFFB26A00));
    default:
      return (bg: const Color(0xFFDDF2E6), fg: const Color(0xFF2E7D4F));
  }
}

Widget _typeBadge(String type) {
  final c = _typeColors(type);
  return StatusBadge(
    status: type,
    backgroundColor: c.bg,
    textColor: c.fg,
    fontSize: 11,
  );
}

class _MessageState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _MessageState({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined, size: 32, color: Color(0xFF6B7280)),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color color;
  const _Avatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        initials,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final LabReportResponse report;
  final Color avatarColor;
  final VoidCallback onTap;

  const _ReportCard({
    required this.report,
    required this.avatarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeLabel = radiologistReportTypeLabel(report.reportType);

    return AppCard(
      onTap: onTap,
      bgColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.zero,
      border: const BorderSide(color: Colors.transparent, width: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(
            initials: radiologistInitials(report.patientName),
            color: avatarColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.patientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1B1E2B),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _typeBadge(typeLabel),
                    const SizedBox(width: 8),
                    Text(
                      formatRadiologistDate(report.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  report.findings.trim().isEmpty
                      ? 'No findings added'
                      : report.findings,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD7DFF2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF1B1E2B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
