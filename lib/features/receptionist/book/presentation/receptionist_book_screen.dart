import 'package:flutter/material.dart';
import 'package:frontend/core/router/app_routes.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/app_text_field.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/core/widgets/stepper/widget/receptionist_booking_stepper.dart';
import 'package:frontend/features/receptionist/book/presentation/booking_confirmation_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistBookScreen extends StatefulWidget {
  const ReceptionistBookScreen({super.key});

  @override
  State<ReceptionistBookScreen> createState() => _ReceptionistBookScreenState();
}

class _ReceptionistBookScreenState extends State<ReceptionistBookScreen> {
  int currentStep = 0;
  bool bookingConfirmed = false;

  String? selectedPatient;
  String? selectedDoctor;

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

  @override
  Widget build(BuildContext context) {
    if (bookingConfirmed) {
      return BookingConfirmationScreen(
        patientName: selectedPatient ?? 'Sarah Mitchell',
        doctorName: selectedDoctor ?? 'Dr. Rachel Nguyen',
        onBookAnother: () {
          setState(() {
            bookingConfirmed = false;
            currentStep = 0;
            selectedPatient = null;
            selectedDoctor = null;
            dateController.clear();
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
            _buildCurrentStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    if (currentStep == 0) {
      return _buildPatientList();
    }

    if (currentStep == 1) {
      return _buildDoctorsList();
    }

    if (currentStep == 2) {
      return _buildSelectTimeAndDate();
    }

    return const SizedBox();
  }

  Widget _buildDoctorsList() {
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
                        "A",
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
                          "patient Name",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "+91 9999999999",
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
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
        ],
      ),
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
                        "A",
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
                          "Patient Name",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Dr. Doctor Name - specialization",
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
                String formattedDate =
                    "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
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
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  availableTimes[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
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
          AppTextField(hintText: "Any notes for the doctor", maxLines: 4),
          SizedBox(height: 15),
          PrimaryButton.primary(
            text: "Confirm",
            onPressed: () {
              context.push(
                AppRoutes.receptionistBookingConfirmation,
                extra: {
                  'patientName': selectedPatient ?? 'Sarah Mitchell',
                  'doctorName': selectedDoctor ?? 'Dr. Rachel Nguyen',
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            "Find a patient",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            "Search and select the patient before choosing a doctor",
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 10),
          AppSearchBar(hintText: "Search by patient name", isFilled: true),
          SizedBox(height: 15),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
          _buildSearchCard(),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPatient = "patient Name";
          currentStep++;
        });
      },
      child: AppCard(
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
                    "A",
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
                      "patient Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "+91 9999999999",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                Spacer(flex: 7),
                Icon(LucideIcons.chevronRight),
              ],
            ),
          ],
        ),
      ),
    );
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
