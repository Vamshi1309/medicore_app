import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_text_styles.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/primary_button.dart';

class PharmacistPrescriptionScreen extends StatefulWidget {
  const PharmacistPrescriptionScreen({super.key});

  @override
  State<PharmacistPrescriptionScreen> createState() =>
      _PharmacistPrescriptionScreenState();
}

class _PharmacistPrescriptionScreenState
    extends State<PharmacistPrescriptionScreen>
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
                        indicatorPadding: const EdgeInsets.symmetric(vertical: 6),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
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
                          _buildPendingList(),
                          _buildCompletedList(),
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

  Widget _buildPendingList() {
    final pending = [
      PendingPrescriptionCard(
        initials: 'RK',
        patientName: 'Ravi Kumar',
        patientId: 'RX-2084 • Age 34',
        doctorName: 'Dr. Ananya Sharma',
        datetime: 'Today, 09:00 AM',
        medicineCount: 3,
        status: 'Pending',
      ),
      PendingPrescriptionCard(
        initials: 'MP',
        patientName: 'Meera Patel',
        patientId: 'RX-2083 • Age 42',
        doctorName: 'Dr. Vikram Singh',
        datetime: 'Today, 10:30 AM',
        medicineCount: 2,
        status: 'Pending',
      ),
      PendingPrescriptionCard(
        initials: 'AN',
        patientName: 'Arjun Nair',
        patientId: 'RX-2082 • Age 29',
        doctorName: 'Dr. Rohan Mehta',
        datetime: 'Yesterday, 04:15 PM',
        medicineCount: 4,
        status: 'Pending',
      ),
    ];

    return ListView.separated(
      itemCount: pending.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) => pending[index],
    );
  }

  Widget _buildCompletedList() {
    final completed = [
      CompletedPrescriptionCard(
        initials: 'SP',
        patientName: 'Sneha Pillai',
        patientId: 'RX-2081 • Age 38',
        doctorName: 'Dr. Neha Kapoor',
        datetime: 'Today, 10:24 AM',
        medicineCount: 3,
        by: 'Priya',
        amount: '₹284',
      ),
      CompletedPrescriptionCard(
        initials: 'KM',
        patientName: 'Karan Malhotra',
        patientId: 'RX-2080 • Age 46',
        doctorName: 'Dr. Arvind Rao',
        datetime: 'Today, 09:42 AM',
        medicineCount: 2,
        by: 'Priya',
        amount: '₹156',
      ),
      CompletedPrescriptionCard(
        initials: 'DV',
        patientName: 'Diya Verma',
        patientId: 'RX-2079 • Age 31',
        doctorName: 'Dr. Rohan Mehta',
        datetime: 'Yesterday, 04:50 PM',
        medicineCount: 4,
        by: 'Priya',
        amount: '₹492',
      ),
    ];

    return ListView.separated(
      itemCount: completed.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) => completed[index],
    );
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: Colors.white,
                    fontSize: 26,
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
  final String initials;
  final String patientName;
  final String patientId;
  final String doctorName;
  final String datetime;
  final int medicineCount;
  final String status;

  const PendingPrescriptionCard({
    super.key,
    required this.initials,
    required this.patientName,
    required this.patientId,
    required this.doctorName,
    required this.datetime,
    required this.medicineCount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = const Color(0xFFF7DCA8);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF18314F),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: const Color(0xFF7A4D00),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      patientId,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF6D7F96),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Prescribed by',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF6F7E94),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctorName,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF1E2D3D),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 17, color: Color(0xFF607A91)),
              const SizedBox(width: 6),
              Text(
                datetime,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.medical_services_outlined, size: 17, color: Color(0xFF607A91)),
              const SizedBox(width: 4),
              Text(
                '$medicineCount medicines',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton.primary(
            text: 'Dispense',
            onPressed: () {},
            color: const Color(0xFF1BA7EF),
            fontSize: 18,
            suffixIcon: Icons.arrow_forward_rounded,
          ),
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
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
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
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
                              fontSize: 20,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD8F5EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Completed',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: const Color(0xFF1A7B5E),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Prescribed by',
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF6F7E94),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            doctorName,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF1E2D3D),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time_rounded, size: 17, color: Color(0xFF607A91)),
              const SizedBox(width: 6),
              Text(
                datetime,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(Icons.medical_services_outlined, size: 17, color: Color(0xFF607A91)),
              const SizedBox(width: 4),
              Text(
                '$medicineCount medicines',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF607A91),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Color(0xFF1EAF74), size: 18),
              const SizedBox(width: 8),
              Text(
                'Dispensed by',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF4B6079),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                by,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF1B2F43),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                amount,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF1D2F42),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
