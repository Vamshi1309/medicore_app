import 'dart:async';
import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';

/// Upload report screen. UI only: mock appointments, mock file picker,
/// fake upload delay. No API integration.
class RadiologistUploadScreen extends StatefulWidget {
  const RadiologistUploadScreen({super.key});

  @override
  State<RadiologistUploadScreen> createState() => _RadiologistUploadScreenState();
}

class _RadiologistUploadScreenState extends State<RadiologistUploadScreen> {
  // Local palette (only AppColors.primary is assumed to exist).
  static const _bg = Color(0xFFEAEFFA);
  static const _textDark = Color(0xFF1B1E2B);
  static const _textGrey = Color(0xFF6B7280);
  static const _border = Color(0xFFD7DFF2);

  static const _reportTypes = [
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

  final _appointments = const <_Appointment>[
    _Appointment(
      'a1',
      'Maya Thompson',
      'Jun 12, 2025',
      '10:30 AM',
      'Scheduled',
    ),
    _Appointment('a2', 'James Wilson', 'Jun 12, 2025', '11:15 AM', 'Completed'),
    _Appointment(
      'a3',
      'Olivia Martin',
      'Jun 11, 2025',
      '09:00 AM',
      'Completed',
    ),
    _Appointment('a4', 'Daniel Brooks', 'Jun 11, 2025', '02:45 PM', 'Pending'),
    _Appointment(
      'a5',
      'Sophia Carter',
      'Jun 10, 2025',
      '04:00 PM',
      'Scheduled',
    ),
  ];

  final _searchController = TextEditingController();
  final _findingsController = TextEditingController();

  String _query = '';
  _Appointment? _selectedAppointment;
  String? _selectedType;
  _PickedFile? _pickedFile;
  bool _isUploading = false;

  bool get _canUpload =>
      _selectedAppointment != null &&
      _selectedType != null &&
      _pickedFile != null &&
      !_isUploading;

  List<_Appointment> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _appointments;
    return _appointments
        .where((a) => a.patient.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _findingsController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- actions

  void _pickFile() {
    // MOCK picker. To use a real one, add the `file_picker` package and:
    //
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    // );
    // if (result == null) return;
    // final f = result.files.single;
    // setState(() => _pickedFile = _PickedFile(f.name, f.size));
    setState(
      () => _pickedFile = const _PickedFile('chest_report_scan.pdf', 2516582),
    );
  }

  Future<void> _upload() async {
    setState(() => _isUploading = true);
    await Future<void>.delayed(
      const Duration(milliseconds: 1500),
    ); // fake request
    if (!mounted) return;
    setState(() => _isUploading = false);

    await showDialog<void>(
      context: context,
      builder: (_) => const _SuccessDialog(),
    );
    if (!mounted) return;
    _resetForm();
  }

  void _resetForm() {
    _searchController.clear();
    _findingsController.clear();
    setState(() {
      _query = '';
      _selectedAppointment = null;
      _selectedType = null;
      _pickedFile = null;
    });
  }

  // ------------------------------------------------------------------ build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Select appointment'),
                    _buildSearchField(),
                    const SizedBox(height: 8),
                    _buildAppointmentList(),
                    const SizedBox(height: 18),
                    const _SectionTitle('Report type'),
                    _buildTypeChips(),
                    const SizedBox(height: 18),
                    const _SectionTitle('Findings', optional: true),
                    _buildFindingsField(),
                    const SizedBox(height: 18),
                    const _SectionTitle('Attach file'),
                    _buildFileArea(),
                    const SizedBox(height: 24),
                    PrimaryButton.primary(
                      text: 'Upload report',
                      prefixIcon: Icons.cloud_upload_outlined,
                      isLoading: _isUploading,
                      enabled: _canUpload,
                      onPressed: _canUpload ? _upload : null,
                    ),
                  ],
                ),
              ),
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
            'Upload report',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Attach a report to a patient appointment',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------- step 1: appointment

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      onChanged: (v) => setState(() => _query = v),
      style: const TextStyle(fontSize: 14, color: _textDark),
      decoration: _fieldDecoration(
        hint: 'Search by patient name',
        prefix: const Icon(Icons.search_rounded, color: _textGrey, size: 20),
        suffix: _query.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded, color: _textGrey, size: 20),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                },
              ),
      ),
    );
  }

  Widget _buildAppointmentList() {
    final items = _filtered;
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(Icons.person_search_outlined, size: 28, color: _textGrey),
            SizedBox(height: 6),
            Text(
              'No appointments match this name',
              style: TextStyle(color: _textGrey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final visibleCount = items.length > 5 ? 5 : items.length;
    const cardHeight = 84.0;
    final listHeight = visibleCount * cardHeight + (visibleCount - 1) * 4.0;

    return SizedBox(
      height: listHeight,
      child: ListView.separated(
        primary: false,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final a = items[index];
          return SizedBox(
            height: cardHeight,
            child: _AppointmentCard(
              appointment: a,
              avatarColor:
                  _avatarColors[_appointments.indexOf(a) %
                      _avatarColors.length],
              selected: _selectedAppointment?.id == a.id,
              onTap: () => setState(() => _selectedAppointment = a),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------- step 2: type

  Widget _buildTypeChips() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _reportTypes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        mainAxisExtent: 42,
      ),
      itemBuilder: (context, index) {
        final type = _reportTypes[index];
        return _TypeChip(
          label: type,
          selected: _selectedType == type,
          onTap: () => setState(() => _selectedType = type),
        );
      },
    );
  }

  // ----------------------------------------------------- step 3: findings

  Widget _buildFindingsField() {
    return TextField(
      controller: _findingsController,
      minLines: 4,
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      style: const TextStyle(fontSize: 16, color: _textDark),
      decoration: _fieldDecoration(hint: 'Add notes or findings'),
    );
  }

  // ----------------------------------------------------------- step 4: file

  Widget _buildFileArea() {
    final file = _pickedFile;

    if (file == null) {
      return InkWell(
        onTap: _pickFile,
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.primary.withValues(alpha: 0.6),
            radius: 20,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.upload_file_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
                SizedBox(height: 10),
                Text(
                  'Choose PDF or image',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'PDF, JPG or PNG',
                  style: TextStyle(color: _textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              file.isPdf ? Icons.picture_as_pdf_outlined : Icons.image_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  file.readableSize,
                  style: const TextStyle(color: _textGrey, fontSize: 14),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove file',
            icon: const Icon(Icons.close_rounded, color: _textGrey),
            onPressed: _isUploading
                ? null
                : () => setState(() => _pickedFile = null),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- helpers

  InputDecoration _fieldDecoration({
    required String hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: c, width: w),
    );

    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGrey, fontSize: 16),
      prefixIcon: prefix,
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: border(_border),
      enabledBorder: border(_border),
      focusedBorder: border(AppColors.primary, 1.5),
    );
  }
}

// =============================================================== components

class _SectionTitle extends StatelessWidget {
  final String text;
  final bool optional;
  const _SectionTitle(this.text, {this.optional = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF1B1E2B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (optional) ...[
            const SizedBox(width: AppSizes.sm),
            const Text(
              'Optional',
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final _Appointment appointment;
  final Color avatarColor;
  final bool selected;
  final VoidCallback onTap;

  const _AppointmentCard({
    required this.appointment,
    required this.avatarColor,
    required this.selected,
    required this.onTap,
  });

  ({Color bg, Color fg}) get _statusColors {
    switch (appointment.status) {
      case 'Completed':
        return (bg: const Color(0xFFDDF2E6), fg: const Color(0xFF2E7D4F));
      case 'Pending':
        return (bg: const Color(0xFFFCEBCF), fg: const Color(0xFFB26A00));
      default:
        return (bg: const Color(0xFFDCE8FB), fg: AppColors.primary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors;

    return AppCard(
      onTap: onTap,
      bgColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.zero,
      border: BorderSide(
        color: selected ? AppColors.primary : Colors.transparent,
        width: selected ? 2 : 1,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(
              appointment.initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patient,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1B1E2B),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${appointment.date}, ${appointment.time}',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                StatusBadge(
                  status: appointment.status,
                  backgroundColor: colors.bg,
                  textColor: colors.fg,
                  fontSize: 11,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: selected
                ? const Icon(
                    Icons.check_circle_rounded,
                    key: ValueKey('on'),
                    color: AppColors.primary,
                    size: 24,
                  )
                : const Icon(
                    Icons.radio_button_unchecked_rounded,
                    key: ValueKey('off'),
                    color: Color(0xFFC3CCE0),
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFD7DFF2),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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

class _SuccessDialog extends StatelessWidget {
  const _SuccessDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFDDF2E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: Color(0xFF2E7D4F),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Report uploaded',
              style: TextStyle(
                color: Color(0xFF1B1E2B),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The report is now attached to the appointment.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
            ),
            const SizedBox(height: 24),
            PrimaryButton.primary(
              text: 'Done',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Draws a dashed rounded-rectangle border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dash;
  final double gap;

  const _DashedBorderPainter({
    required this.color,
    this.radius = 20,
    this.dash = 8,
    this.gap = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + dash), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

// ============================================================== mock models

class _Appointment {
  final String id;
  final String patient;
  final String date;
  final String time;
  final String status;

  const _Appointment(this.id, this.patient, this.date, this.time, this.status);

  String get initials {
    final parts = patient.trim().split(RegExp(r'\s+'));
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }
}

class _PickedFile {
  final String name;
  final int sizeInBytes;

  const _PickedFile(this.name, this.sizeInBytes);

  bool get isPdf => name.toLowerCase().endsWith('.pdf');

  String get readableSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
