import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistAppCard extends StatefulWidget {
  const ReceptionistAppCard({super.key});

  @override
  State<ReceptionistAppCard> createState() => _ReceptionistAppCardState();
}

class _ReceptionistAppCardState extends State<ReceptionistAppCard> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Text(
                  "VD",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vamshi Dasari",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Uday Kummar . Dermatology",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        size: 12,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: 3),
                      Text(
                        "10:30 AM",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: StatusBadge(
                  status: AppointmentStatus.confirmed.label,
                  backgroundColor: AppointmentStatus.confirmed.backgroundColor,
                  textColor: AppointmentStatus.confirmed.textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (!isTapped) ...[
            Divider(height: 25),
            SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton.primary(
                      text: "Confirm",
                      fontSize: 16,
                      prefixIcon: LucideIcons.check,
                      isTextBold: true,
                      onPressed: () {
                        setState(() {
                          isTapped = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton.primary(
                      text: "Cancel",
                      fontSize: 16,
                      isTextBold: false,
                      color: Colors.red.shade100,
                      prefixIcon: LucideIcons.x,
                      foregroundColor: Colors.red,
                      onPressed: () {
                        setState(() {
                          isTapped = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
