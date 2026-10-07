import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PatientBookingStep {
  final String title;
  final IconData icon;

  const PatientBookingStep({
    required this.title,
    required this.icon,
  });
}

const bookingSteps = [
  PatientBookingStep(title: "Doctor", icon: LucideIcons.userRound),
  PatientBookingStep(title: "Date", icon: LucideIcons.calendarDays),
  PatientBookingStep(title: "Time", icon: LucideIcons.clock3),
  PatientBookingStep(title: "Notes", icon: LucideIcons.fileText),
  PatientBookingStep(title: "Confirm", icon: LucideIcons.check),
];