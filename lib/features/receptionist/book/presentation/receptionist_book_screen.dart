import 'package:flutter/material.dart';
import 'package:frontend/core/widgets/app_card.dart';
import 'package:frontend/core/widgets/app_search_bar.dart';
import 'package:frontend/core/widgets/stepper/widget/receptionist_booking_stepper.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ReceptionistBookScreen extends StatefulWidget {
  const ReceptionistBookScreen({super.key});

  @override
  State<ReceptionistBookScreen> createState() => _ReceptionistBookScreenState();
}

class _ReceptionistBookScreenState extends State<ReceptionistBookScreen> {
  int currentStep = 0;

  String? selectedPatient;
  String? selectedDoctor;

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () {  }, 
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
