import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Text("S"),
          ),
          SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr. Vamshi Dasari",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                "Dermatologist . 12 yrs",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.grey500),
              ),
              SizedBox(height: 1),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.yellow.shade700),
                  SizedBox(width: 5),
                  Text("4.9", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
