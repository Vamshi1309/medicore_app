import 'package:flutter/material.dart';

class ReceptionistBookingStep {
  final String title;
  final IconData? icon;

  const ReceptionistBookingStep({
    required this.title,
    this.icon,
  });
}

const receptionistBookingSteps = [
  ReceptionistBookingStep(
    title: 'Patient',
  ),
  ReceptionistBookingStep(
    title: 'Doctor',
  ),
  ReceptionistBookingStep(
    title: 'Schedule',
  ),
];