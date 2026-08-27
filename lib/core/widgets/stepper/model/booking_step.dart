import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BookingStep {
  final String title;
  final IconData icon;

  const BookingStep({
    required this.title,
    required this.icon,
  });
}

const bookingSteps = [
  BookingStep(title: "Doctor", icon: LucideIcons.userRound),
  BookingStep(title: "Date", icon: LucideIcons.calendarDays),
  BookingStep(title: "Time", icon: LucideIcons.clock3),
  BookingStep(title: "Notes", icon: LucideIcons.fileText),
  BookingStep(title: "Confirm", icon: LucideIcons.check),
];