import 'package:intl/intl.dart';

class AppointmentBookingState {
  final String? doctorId;
  final DateTime? selectedDate;
  final String? selectedTime;
  final String? notes;

  const AppointmentBookingState({
    this.doctorId,
    this.selectedDate,
    this.selectedTime,
    this.notes,
  });

  AppointmentBookingState copyWith({
    String? doctorId,
    DateTime? selectedDate,
    String? selectedTime,
    String? notes,
  }) {
    return AppointmentBookingState(
      doctorId: doctorId ?? this.doctorId,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson(String patientId) {
    final parsedTime = DateFormat('hh:mm a').parse(selectedTime!);

    final scheduledAt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'notes': notes,
    };
  }
}
