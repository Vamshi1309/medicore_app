import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';

/// My Reports screen. UI only: mock reports, local search + type filter,
/// details bottom sheet. No API integration.
class RadiologistReportsScreen extends StatefulWidget {
  const RadiologistReportsScreen({super.key});

  @override
  State<RadiologistReportsScreen> createState() =>
      _RadiologistReportsScreenState();
}

class _RadiologistReportsScreenState extends State<RadiologistReportsScreen> {
  static const _bg = Color(0xFFEAEFFA);
  static const _textDark = Color(0xFF1B1E2B);
  static const _textGrey = Color(0xFF6B7280);
  static const _border = Color(0xFFD7DFF2);

  static const _filters = [
    'All',
    'X-Ray',
    'MRI',
    'CT Scan',
    'Blood Test',
    'Urine Test',
    'Ultrasound',
  ];

  static const _avatarColors = [
    Color(0xFFE8DDF3), // lavender
    Color(0xFFDCE8FB), // light blue
    Color(0xFFF5E8BF), // cream
    Color(0xFFDDF2E6), // mint
    Color(0xFFFBE0DD), // blush
  ];

  final _reports = const <_Report>[
    _Report(
      'r1',
      'Maya Thompson',
      'MRI',
      'Jun 12, 2025',
      'Mild disc bulge at L4-L5 without nerve root compression. No signal abnormality in the spinal cord. Recommend follow-up if symptoms persist.',
      'maya_thompson_mri.pdf',
      '2.4 MB',
    ),
    _Report(
      'r2',
      'James Wilson',
      'X-Ray',
      'Jun 12, 2025',
      'No acute fracture or dislocation. Joint spaces are preserved. Soft tissues appear normal.',
      'james_wilson_xray.jpg',
      '1.1 MB',
    ),
    _Report(
      'r3',
      'Olivia Martin',
      'CT Scan',
      'Jun 11, 2025',
      'Small nodule (4 mm) in the right upper lobe. No pleural effusion. Suggest repeat CT in 6 months.',
      'olivia_martin_ct.pdf',
      '5.8 MB',
    ),
    _Report(
      'r4',
      'Daniel Brooks',
      'Blood Test',
      'Jun 11, 2025',
      '',
      'daniel_brooks_blood.pdf',
      '320 KB',
    ),
    _Report(
      'r5',
      'Sophia Carter',
      'Ultrasound',
      'Jun 10, 2025',
      'Gallbladder is normal in size with no stones. Liver echotexture is homogeneous. No free fluid in the abdomen.',
      'sophia_carter_us.png',
      '1.9 MB',
    ),
    _Report(
      'r6',
      'Liam Harris',
      'Urine Test',
      'Jun 09, 2025',
      'Trace protein detected. No glucose or ketones. Microscopy shows no significant cells or casts.',
      'liam_harris_urine.pdf',
      '210 KB',
    ),
    _Report(
      'r7',
      'Ava Johnson',
      'X-Ray',
      'Jun 08, 2025',
      'Healed fracture of the left radius with good alignment. No new bony abnormality.',
      'ava_johnson_xray.jpg',
      '1.4 MB',
    ),
  ];

  final _searchController = TextEditingController();
  String _query = '';
  String _selectedFilter = 'All';

  List<_Report> get _filtered {
    final q = _query.trim().toLowerCase();
    return _reports.where((r) {
      final matchesName = q.isEmpty || r.patient.toLowerCase().contains(q);
      final matchesType =
          _selectedFilter == 'All' || r.type == _selectedFilter;
      return matchesName && matchesType;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    final items = _filtered;

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
                Text(
                  items.length == 1 ? '1 report' : '${items.length} reports',
                  style: const TextStyle(
                    color: _textGrey,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final r = items[index];
                      return _ReportCard(
                        report: r,
                        avatarColor: _avatarColors[
                            _reports.indexOf(r) % _avatarColors.length],
                        onTap: () => _showDetails(r),
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

  // --------------------------------------------------------- details sheet

  void _showDetails(_Report r) {
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
                    initials: r.initials,
                    color: _avatarColors[
                        _reports.indexOf(r) % _avatarColors.length],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.patient,
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
                          r.date,
                          style: const TextStyle(color: _textGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  _typeBadge(r.type),
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
                r.findings.isEmpty ? 'No findings were added.' : r.findings,
                style: TextStyle(
                  color: r.findings.isEmpty ? _textGrey : _textDark,
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
                        r.isPdf
                            ? Icons.picture_as_pdf_outlined
                            : Icons.image_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _textDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            r.fileSize,
                            style:
                                const TextStyle(color: _textGrey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton.primary(
                text: 'Open file',
                prefixIcon: Icons.open_in_new_rounded,
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  // TODO: open the real file (url_launcher / open_filex / viewer).
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${r.fileName}')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================== components

/// Pastel colors per report type, used for the badge.
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
    default: // Ultrasound
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
  final _Report report;
  final Color avatarColor;
  final VoidCallback onTap;

  const _ReportCard({
    required this.report,
    required this.avatarColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          _Avatar(initials: report.initials, color: avatarColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.patient,
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
                    _typeBadge(report.type),
                    const SizedBox(width: 8),
                    Text(
                      report.date,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  report.findings.isEmpty
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

// ============================================================== mock models

class _Report {
  final String id;
  final String patient;
  final String type;
  final String date;
  final String findings;
  final String fileName;
  final String fileSize;

  const _Report(
    this.id,
    this.patient,
    this.type,
    this.date,
    this.findings,
    this.fileName,
    this.fileSize,
  );

  bool get isPdf => fileName.toLowerCase().endsWith('.pdf');

  String get initials {
    final parts = patient.trim().split(RegExp(r'\s+'));
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}