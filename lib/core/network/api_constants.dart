class ApiConstants {
  ApiConstants._();

  //baseUrl endpoint
  // static const String baseUrl = "http://localhost:8080/api";
  static const String baseUrl = "http://192.168.1.21:8080/api";

  //auth endpoints
  static const String patientLogin = "/auth/login";
  static const String staffLogin = "/auth/staff/login";
  static const String refreshToken = "/auth/refresh";
  static const String logout = "/auth/logout";
  static const String sendRegisterOtp = "/auth/register/send-otp";
  static const String verifyRegisterOtp = "/auth/register/verify-otp";
  static const String sendLoginOtp = "/auth/login/send-otp";
  static const String verifyLoginOtp = "/auth/login/verify-otp";
  static const String me = "/auth/me";

  //patient endpoints
  static String getPatientProfile = "/patient/profile";

  //doctor endpoints
  static String getAllDoctors = "/doctor/all";

  //appointment endpoints
  static String getAppointmentsByPatientId(String patientId) =>
      "/appointments/patient/$patientId";
  static const String createAppointment = "/appointments";
  static const String getAllAppointments = "/appointments";
  static String getAppointmentsByDoctorId(String doctorId) =>
      "/appointments/doctor/$doctorId";
  static String getAppointmentsById(String appointmentId) =>
      "/appointments/$appointmentId";
  static String updateAppointmentStatus(String appointmentId) =>
      "/appointments/$appointmentId/status";

  //prescriptions endpoints
  static String createPrescription = "/prescriptions";
  static String getPrescriptionsByPatientId(String patiendId) =>
      "/prescriptions/patient/$patiendId";
  static String downloadPrescription(String prescriptionId) =>
      "/prescriptions/$prescriptionId/download";
  static String getPrescriptionByAppointmentId(String appointmentId) =>
      "/prescriptions/appointment/$appointmentId";
  static String updatePrescription(String prescripionId) =>
      "/prescriptions/$prescripionId";

  //lab-reports endpoints
  static String getLabReportsByPatientId(String patientId) =>
      "/lab-reports/patient/$patientId";
  static String getLabReportDownloadUrl(String reportId) =>
      "/lab-reports/$reportId/download-url";

  //Pharmacy endpoints
  static String getDispenseHistoryByPatientId(String patientId) =>
      "/pharmacy/history/patient/$patientId";

  //Inventory Endpoints
  static String getAllMedicines = "/inventory";
}
