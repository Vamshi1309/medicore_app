import 'package:flutter/material.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final String patientName;
  final String doctorName;
  final VoidCallback onBookAnother;

  const BookingConfirmationScreen({
    super.key,
    required this.patientName,
    required this.doctorName,
    required this.onBookAnother,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF3FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 68,
                  width: 68,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF4778FF), Color(0xFF2852D9)],
                    ),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 34),
                ),
                const SizedBox(height: 18),

                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101D35),
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  patientName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF68758A),
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  doctorName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF68758A),
                  ),
                ),
                const SizedBox(height: 28),

                SizedBox(
                  width: 132,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: onBookAnother,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3765EC),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Book Another',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
