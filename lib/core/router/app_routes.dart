class AppRoutes {
  AppRoutes._();

  // auth routes
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';

  //patient routes
  static const patientHome = '/home';
  static const patientAppointment = '/patient-appointment';
  static const patientRecord = '/patient-records';
  static const patientProfile = '/patient-profile';
  static const editPatientProfile = '/patient-profile/edit';

  //doctor routes
   static const doctorHome = '/doctor-home';

  //create appointment routes
  static const bookAppointment = '/book-appointment';
  static const String bookAppointmentDate = '$bookAppointment/date';
  static const String bookAppointmentTime = '$bookAppointment/time';
  static const String bookAppointmentNotes = '$bookAppointment/notes';
  static const String bookAppointmentConfirm = '$bookAppointment/confirm';
}
