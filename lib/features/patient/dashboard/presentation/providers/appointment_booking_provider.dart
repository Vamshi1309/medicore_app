import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/patient/dashboard/presentation/state/appointment_state.dart';

class AppointmentBookingNotifier extends Notifier<AppointmentBookingState> {
  @override
  AppointmentBookingState build() {
    return const AppointmentBookingState();
  }

  void setDoctor(String doctorId) {
    state = state.copyWith(doctorId: doctorId);
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTime(String time) {
    state = state.copyWith(selectedTime: time);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void clear() {
    state = const AppointmentBookingState();
  }
}

final appointmentBookingProvider =
    NotifierProvider<AppointmentBookingNotifier, AppointmentBookingState>(
      AppointmentBookingNotifier.new,
    );
