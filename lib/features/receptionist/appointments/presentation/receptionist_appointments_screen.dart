import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/receptionist/widgets/receptionist_app_card.dart';

class ReceptionistAppointmentsScreen extends StatelessWidget {
  const ReceptionistAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopHeader(context),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            ReceptionistAppCard(),
            SizedBox(height: 10),
            ReceptionistAppCard(),
            SizedBox(height: 10),
            ReceptionistAppCard(),
          ]),
        ),
      ],
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 32,
          left: AppSizes.lg,
          right: AppSizes.lg,
          bottom: AppSizes.lg,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Manage',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "Appointments",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      //specialtyBadge(),
                    ],
                  ),
                ),
                StatusBadge(
                  status: "7 Total",
                  backgroundColor: Colors.white24,
                  textColor: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 10),
            AppSearchBar(hintText: "Search Doctor..."),
          ],
        ),
      ),
    );
  }
}
