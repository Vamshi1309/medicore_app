import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/lab_reports_provider.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/prescription_provider.dart';
import 'package:frontend/features/patient/records/presentation/providers/pharmacy_provider.dart';
import 'package:frontend/features/patient/records/presentation/screens/dispense_history_screen.dart';
import 'package:frontend/features/patient/records/presentation/screens/lab_reports_screen.dart';
import 'package:frontend/features/patient/records/presentation/screens/prescription_screen.dart';
import 'package:frontend/features/patient/widgets/app_header.dart';

class RecordsScreen extends ConsumerStatefulWidget {
  const RecordsScreen({super.key});

  @override
  ConsumerState<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends ConsumerState<RecordsScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(pharmacyProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          final message = error is ApiException
              ? error.message
              : "Something went wrong";

          AppSnackBar.error(context, message);
        },
      );
    });

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
    final prescriptionAsync = ref.watch(prescriptionProvider);
    final labReportsAsync = ref.watch(labReportsProvider);
    final dispenseAsync = ref.watch(pharmacyProvider);

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
                  StatCard(
                    count: prescriptionAsync.when(
                      error: (_, _) => Text(
                        "0",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      data: (list) => Text(
                        list.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    heading: "Prescription",
                  ),
                  StatCard(
                    count: labReportsAsync.when(
                      error: (_, _) => Text(
                        "0",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      data: (list) => Text(
                        list.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    heading: "lab report",
                  ),
                  StatCard(
                    count: dispenseAsync.when(
                      error: (_, _) => Text(
                        "0",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      data: (list) => Text(
                        list.length.toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    heading: "dispense history",
                  ),
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
