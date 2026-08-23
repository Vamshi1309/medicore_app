import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/network/api_exception.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/empty_state.dart';
import 'package:frontend/features/patient/records/presentation/providers/pharmacy_provider.dart';
import 'package:frontend/features/patient/records/widgets/record_dispense_history_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DispenseHistoryScreen extends ConsumerStatefulWidget {
  const DispenseHistoryScreen({super.key});

  @override
  ConsumerState<DispenseHistoryScreen> createState() =>
      _DispenseHistoryScreenState();
}

class _DispenseHistoryScreenState extends ConsumerState<DispenseHistoryScreen> {
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
  }

  @override
  Widget build(BuildContext context) {
    final dispenseHistoryAsync = ref.watch(pharmacyProvider);

    return dispenseHistoryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),

      error: (error, _) => Center(
        child: Text(
          error is ApiException ? error.message : "Something went wrong",
        ),
      ),

      data: (dispenseHistory) {
        if (dispenseHistory.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: LucideIcons.packageOpen,
              title: "No dispense history available",
              subtitle: "Your dispensed medicines will appear here.",
            ),
          );
        }

        final medicineCount = dispenseHistory.fold<int>(
          0,
          (total, dispense) => total + dispense.items.length,
        );

        return ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '$medicineCount medicines dispensed',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6F7785),
                ),
              ),
            ),

            const SizedBox(height: 8),

            ...dispenseHistory.expand(
              (dispense) => dispense.items.map(
                (item) => RecordDispenseHistoryCard(
                  medicineName: item.medicineName,
                  price: item.totalPrice,
                  tabletCount: item.quantityDispensed,
                  pharmacistName: dispense.dispensedByName,
                  date: formatDate(dispense.dispensedAt),
                ),
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
