import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/patient/records/presentation/dispense_history_screen.dart';
import 'package:frontend/features/patient/records/presentation/lab_reports_screen.dart';
import 'package:frontend/features/patient/records/presentation/prescription_screen.dart';
import 'package:frontend/features/patient/widgets/app_header.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppHeader(
                title: "My Records",
                greeting: "Medical Records",
                statCards: [
                  StatCard(count: "4", heading: "Prescription"),
                  StatCard(count: "2", heading: "lab report"),
                  StatCard(count: "1", heading: "dispense history"),
                ],
              ),
              const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 0.25,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: "Prescriptions"),
                  Tab(text: "Lab Reports"),
                  Tab(text: "Dispense History"),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    PrescriptionsScreen(),
                    LabReportsScreen(),
                    DispenseHistoryScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
