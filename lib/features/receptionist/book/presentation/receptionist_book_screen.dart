import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/error_state.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/stepper/widget/receptionist_booking_stepper.dart';
import 'package:frontend/features/admin/data/models/user_summary_response.dart';
import 'package:frontend/features/appointment/providers/all_appointments_provider.dart';
import 'package:frontend/features/doctor/dashboard/data/models/doctor_profile_response.dart';
import 'package:frontend/features/patient/dashboard/presentation/providers/get_all_doctors_provider.dart';
import 'package:frontend/features/receptionist/book/presentation/booking_confirmation_screen.dart';
import 'package:frontend/features/receptionist/book/presentation/models/book_appointment_model.dart';
import 'package:frontend/features/receptionist/book/presentation/providers/receptionist_book_appointment_provider.dart';
import 'package:frontend/features/receptionist/book/presentation/providers/receptionist_patients_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistBookScreen extends ConsumerStatefulWidget {
  const ReceptionistBookScreen({super.key});

  @override
  ConsumerState<ReceptionistBookScreen> createState() =>
      _ReceptionistBookScreenState();
}

class _ReceptionistBookScreenState
    extends ConsumerState<ReceptionistBookScreen> {
  int currentStep = 0;
  bool bookingConfirmed = false;

  UserSummaryResponse? selectedPatient;
  DoctorProfileResponse? selectedDoctor;

  final List<String> availableTimes = [
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '13:00',
    '14:00',
    '15:00',
  ];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final receptionistPatientsState = ref.watch(receptionistPatientsProvider);
    final receptionistDoctorsState = ref.watch(getAllDoctorsProvider);

    if (bookingConfirmed) {
      return BookingConfirmationScreen(
        patientName: selectedPatient?.name ?? 'No Patient Selected',
        doctorName: selectedDoctor?.name ?? 'Dr. Rachel Nguyen',
        onBookAnother: () {
          setState(() {
            bookingConfirmed = false;
            currentStep = 0;
            selectedPatient = null;
            selectedDoctor = null;
            dateController.clear();
            timeController.clear();
            notesController.clear();
          });
        },
      );
    }
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            ReceptionistBookingStepper(currentStep: currentStep),
            _buildCurrentStep(
              receptionistPatientsState,
              receptionistDoctorsState,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    AsyncValue<List<UserSummaryResponse>> receptionistPatientsState,
    AsyncValue<List<DoctorProfileResponse>> receptionistDoctorsState,
  ) {
    if (currentStep == 0) {
      return _buildPatientList(receptionistPatientsState);
    }

    if (currentStep == 1) {
      return _buildDoctorsList(receptionistDoctorsState);
    }

    if (currentStep == 2) {
      return _buildSelectTimeAndDate();
    }

    return const SizedBox();
  }

  Widget _buildDoctorsList(AsyncValue<List<DoctorProfileResponse>> state) {
    return state.when(
      data: (data) {
        if (data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No patients found')),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: Text(
                            getInitials(selectedPatient?.name ?? "NA"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selected Patient",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              selectedPatient?.name ?? "No patient selected",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              selectedPatient?.phoneNumber ?? "No Number",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Spacer(flex: 4),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Change",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Choose a doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Search by doctor name",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 10),
              AppSearchBar(hintText: "Search by doctor name", isFilled: true),
              SizedBox(height: 15),
              ...data.map((doctor) => _buildDoctorCard(doctor)),
            ],
          ),
        );
      },
      error: (err, stackTrace) {
        return ErrorState(title: "Error", subtitle: err.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildSelectTimeAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          AppCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Booking for",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Change doctor",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: Text(
                        getInitials(selectedPatient?.name ?? "NA"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedPatient?.name ?? "No Patient",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Dr. ${selectedDoctor?.name ?? "No Doctor"} - ${selectedDoctor?.specialization ?? "NA"}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(
            "Date",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          AppTextField(
            controller: dateController,
            hintText: "Select a date",
            readOnly: true,
            suffixIcon: LucideIcons.calendarDays,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                final formattedDate =
                    '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';

                setState(() {
                  dateController.text = formattedDate;
                });
              }
            },
          ),
          SizedBox(height: 15),
          Text(
            "Time",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.2,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableTimes.length,
            itemBuilder: (context, index) {
              final time = availableTimes[index];
              final isSelected = timeController.text == time;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    timeController.text = time;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    availableTimes[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15),
          Text(
            "Notes(Optional)",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          AppTextField(
            controller: notesController,
            hintText: "Any notes for the doctor",
            maxLines: 4,
          ),
          SizedBox(height: 15),
          PrimaryButton.primary(
            text: "Confirm",
            onPressed: () async {
              final success = await _submitConfirm();

              if (!mounted || !success) return;

              setState(() {
                bookingConfirmed = true;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList(AsyncValue<List<UserSummaryResponse>> state) {
    return state.when(
      data: (patients) {
        if (patients.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No patients found')),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              const Text(
                "Find a patient",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                "Search and select the patient before choosing a doctor",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              AppSearchBar(hintText: "Search by patient name", isFilled: true),
              const SizedBox(height: 15),

              ...patients.map((patient) => _buildPatientCard(patient)),
            ],
          ),
        );
      },
      error: (err, stackTrace) {
        return ErrorState(title: "Error", subtitle: err.toString());
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildPatientCard(UserSummaryResponse patient) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPatient = patient;
          currentStep = 1;
        });
      },
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Text(
                patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    patient.phoneNumber ?? 'No phone number',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(DoctorProfileResponse doctor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDoctor = doctor;
          currentStep = 2;
        });
      },
      child: AppCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Text(
                doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    doctor.phoneNumber,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight),
          ],
        ),
      ),
    );
  }

  String getInitials(String name) {
    if (name.trim().isEmpty) return '';

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Future<bool> _submitConfirm() async {
    if (selectedPatient == null) {
      AppSnackBar.error(context, 'Please select a patient');
      return false;
    }

    if (selectedDoctor == null) {
      AppSnackBar.error(context, 'Please select a doctor');
      return false;
    }

    if (dateController.text.trim().isEmpty) {
      AppSnackBar.error(context, 'Please select an appointment date');
      return false;
    }

    if (timeController.text.trim().isEmpty) {
      AppSnackBar.error(context, 'Please select an appointment time');
      return false;
    }

    try {
      final selectedDate = DateTime.tryParse(dateController.text.trim());

      if (selectedDate == null) {
        AppSnackBar.error(context, 'Please select a valid date');
        return false;
      }

      // Your available slots are in HH:mm format, e.g. 10:30.
      final timeParts = timeController.text.trim().split(':');

      if (timeParts.length != 2) {
        AppSnackBar.error(context, 'Please select a valid time');
        return false;
      }

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);

      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        AppSnackBar.error(context, 'Please select a valid time');
        return false;
      }

      final scheduledAt = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minute,
      );

      final booking = CreateAppointmentRequest(
        patientId: selectedPatient!.userId,
        doctorId: selectedDoctor!.userId,
        scheduledAt: scheduledAt,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );

      await ref
          .read(receptionistBookAppointmentProvider)
          .createAppointment(booking);

      ref.invalidate(allAppointmentsProvider);

      return true;
    } catch (e) {
      if (!mounted) return false;

      AppSnackBar.error(context, e.toString());
      return false;
    }
  }

  Widget _buildHeader() {
    return Container(
      height: 70,
      width: double.infinity,
      color: Colors.blue,
      padding: const EdgeInsets.only(left: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Book Appointment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
