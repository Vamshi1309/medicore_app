import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/status_badge.dart';
import 'package:frontend/features/appointment/data/models/appointment_response.dart';
import 'package:frontend/features/appointment/data/models/update_appointment_status_model.dart';
import 'package:frontend/features/appointment/providers/all_appointments_provider.dart';
import 'package:frontend/features/patient/appointments/widgets/appointment_card.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistAppCard extends ConsumerStatefulWidget {
  final AppointmentResponse appointment;

  const ReceptionistAppCard({super.key, required this.appointment});

  @override
  ConsumerState<ReceptionistAppCard> createState() =>
      _ReceptionistAppCardState();
}

class _ReceptionistAppCardState extends ConsumerState<ReceptionistAppCard> {
  String getInitials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
  }

  Future<void> updateStatus(String value) async {
    UpdateAppointmentStatusRequest status;
    try {
      if (value.toLowerCase() == "confirm") {
        status = UpdateAppointmentStatusRequest(
          status: AppointmentStatus.confirmed,
        );
      } else {
        status = UpdateAppointmentStatusRequest(
          status: AppointmentStatus.cancelled,
        );
      }

      await ref
          .read(allAppointmentsProvider.notifier)
          .updateAppointmentStatus(status, widget.appointment.appointmentId);
    } catch (e) {
      // ignore: use_build_context_synchronously
      AppSnackBar.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.appointment.status;

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
                  getInitials(widget.appointment.patientName),
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
                    widget.appointment.patientName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "${widget.appointment.doctorName} . ${widget.appointment.doctorSpecialization}",
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
                  status: status.label,
                  backgroundColor: status.backgroundColor,
                  textColor: status.textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          if (status == AppointmentStatus.pending) ...[
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
                      onPressed: () async {
                        await updateStatus("Confirm");
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
                      onPressed: () async {
                        await updateStatus("cancel");
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
