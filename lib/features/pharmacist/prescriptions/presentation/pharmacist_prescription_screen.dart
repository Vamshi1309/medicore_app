import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/theme/app_text_styles.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/prescription/data/models/enums/dispence_status.dart';
import 'package:frontend/features/prescription/providers/all_prescription_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PharmacistPrescriptionScreen extends ConsumerStatefulWidget {
  const PharmacistPrescriptionScreen({super.key});

  @override
  ConsumerState<PharmacistPrescriptionScreen> createState() =>
      _PharmacistPrescriptionScreenState();
}

class _PharmacistPrescriptionScreenState
    extends ConsumerState<PharmacistPrescriptionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showCompleted = _tabController.index == 1;
    final prescriptions = ref.watch(getAllPrescriptionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            HeaderSection(
              eyebrow: showCompleted
                  ? '28 dispensed prescriptions'
                  : '12 waiting to dispense',
              title: 'Prescriptions',
              onSearchPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                color: const Color(0xFFF1F5F9),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorPadding: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        labelPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        dividerColor: Colors.transparent,
                        dividerHeight: 0,
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                        splashFactory: NoSplash.splashFactory,
                        labelColor: const Color(0xFF0B7CDE),
                        unselectedLabelColor: const Color(0xFF7A8EA5),
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        tabs: const [
                          Tab(text: 'Pending'),
                          Tab(text: 'Completed'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    AppSearchBar(
                      controller: _searchController,
                      hintText: 'Search patient or doctor',
                      isFilled: true,
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Pending prescriptions
                          prescriptions.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, stacktrace) => ErrorState(
                              title: "Error",
                              subtitle: err.toString(),
                            ),
                            data: (list) {
                              final pendingList = list
                                  .where(
                                    (prescription) =>
                                        prescription.status ==
                                        DispensingStatus.pending,
                                  )
                                  .toList();

                              if (pendingList.isEmpty) {
                                return EmptyState(
                                  icon: LucideIcons.clipboard,
                                  title: "No Pending Prescriptions",
                                  subtitle: "No prescriptions to dispense",
                                );
                              }

                              return ListView.separated(
                                itemCount: pendingList.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final prescription = pendingList[index];

                                  return PendingPrescriptionCard(
                                    prescriptionId: prescription.prescriptionId,
                                    initials: getInitials(
                                      prescription.patientName,
                                    ),
                                    patientName: prescription.patientName,
                                    patientId: prescription.patientId,
                                    doctorName: prescription.doctorName,
                                    datetime: formatDispenseDate(
                                      prescription.createdAt,
                                    ),
                                    medicineCount: prescription.items.length,
                                    status: prescription.status.apiValue,
                                  );
                                },
                              );
                            },
                          ),

                          // Completed prescriptions
                          prescriptions.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, stacktrace) => ErrorState(
                              title: "Error",
                              subtitle: err.toString(),
                            ),
                            data: (list) {
                              final completedList = list
                                  .where(
                                    (prescription) =>
                                        prescription.status ==
                                        DispensingStatus.completed,
                                  )
                                  .toList();

                              if (completedList.isEmpty) {
                                return EmptyState(
                                  icon: LucideIcons.clipboardCheck,
                                  title: "No Completed Prescriptions",
                                  subtitle:
                                      "No prescriptions have been dispensed yet",
                                );
                              }

                              return ListView.separated(
                                itemCount: completedList.length,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final prescription = completedList[index];

                                  return PendingPrescriptionCard(
                                    prescriptionId: prescription.prescriptionId,
                                    initials: getInitials(
                                      prescription.patientName,
                                    ),
                                    patientName: prescription.patientName,
                                    patientId: prescription.patientId,
                                    doctorName: prescription.doctorName,
                                    datetime: formatDispenseDate(
                                      prescription.createdAt,
                                    ),
                                    medicineCount: prescription.items.length,
                                    status: 'Completed',
                                    showActionButton: false,
                                    isCompleted: true,
                                  );
                                },
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
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    final cleanName = name.trim();

    if (cleanName.isEmpty) {
      return '';
    }

    final parts = cleanName.split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String formatDispenseDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  String formatDispenseTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

class HeaderSection extends StatelessWidget {
  final String eyebrow;
  final String title;
  final VoidCallback onSearchPressed;

  const HeaderSection({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 18, 18, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D8BE7), Color(0xFF1F6FD3)],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xD9EAFBFF),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class PendingPrescriptionCard extends StatelessWidget {
  final String prescriptionId;
  final String initials;
  final String patientName;
  final String patientId;
  final String doctorName;
  final String datetime;
  final int medicineCount;
  final String status;
  final bool showActionButton;
  final bool isCompleted;

  const PendingPrescriptionCard({
    super.key,
    required this.prescriptionId,
    required this.initials,
    required this.patientName,
    required this.patientId,
    required this.doctorName,
    required this.datetime,
    required this.medicineCount,
    required this.status,
    this.showActionButton = true,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isCompleted
        ? const Color(0xFFD8F5EA)
        : const Color(0xFFF7DCA8);
    final statusTextColor = isCompleted
        ? const Color(0xFF1A7B5E)
        : const Color(0xFF7A4D00);
    final badgeStatus = isCompleted ? 'Completed' : status;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF1CA5F8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patientName,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF18314F),
                            ),
                          ),
                        ),
                        StatusBadge(
                          status: badgeStatus,
                          backgroundColor: statusColor,
                          textColor: statusTextColor,
                          fontSize: 10,
                          height: 22,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patientId,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF6D7F96),
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Prescribed by',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF6F7E94),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            doctorName,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF1E2D3D),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Color(0xFF607A91),
              ),
              const SizedBox(width: 6),
              Text(
                datetime,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.medical_services_outlined,
                size: 15,
                color: Color(0xFF607A91),
              ),
              const SizedBox(width: 4),
              Text(
                '$medicineCount medicines',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (showActionButton) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 38,
              child: PrimaryButton.primary(
                text: 'Dispense',
                onPressed: () {
                  context.push(AppRoutes.pharmacistDispensePath(prescriptionId));
                },
                color: const Color(0xFF1BA7EF),
                fontSize: 14,
                suffixIcon: Icons.arrow_forward_rounded,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class CompletedPrescriptionCard extends StatelessWidget {
  final String initials;
  final String patientName;
  final String patientId;
  final String doctorName;
  final String datetime;
  final int medicineCount;
  final String by;
  final String amount;

  const CompletedPrescriptionCard({
    super.key,
    required this.initials,
    required this.patientName,
    required this.patientId,
    required this.doctorName,
    required this.datetime,
    required this.medicineCount,
    required this.by,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF1CA5F8),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patientName,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF18314F),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            patientId,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF6D7F96),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StatusBadge(
                      status: 'Completed',
                      backgroundColor: const Color(0xFFD8F5EA),
                      textColor: const Color(0xFF1A7B5E),
                      fontSize: 10,
                      height: 22,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Prescribed by',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF6F7E94),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            doctorName,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF1E2D3D),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Color(0xFF607A91),
              ),
              const SizedBox(width: 6),
              Text(
                datetime,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.medical_services_outlined,
                size: 15,
                color: Color(0xFF607A91),
              ),
              const SizedBox(width: 4),
              Text(
                '$medicineCount medicines',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1EAF74),
                size: 17,
              ),
              const SizedBox(width: 8),
              Text(
                'Dispensed by',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF4B6079),
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                by,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF1B2F43),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              Text(
                amount,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF1D2F42),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
