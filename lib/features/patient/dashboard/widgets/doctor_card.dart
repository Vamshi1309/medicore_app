import 'package:flutter/material.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/core/widgets/app_card.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String experienceInYears;
  final String speciality;
  final Color color;

  const DoctorCard({
    super.key,
    required this.name,
    required this.experienceInYears,
    required this.speciality,
    required this.color,
  });

  String get initial => name[0].toUpperCase();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Text(initial, style: TextStyle(color: Colors.black)),
          ),
          SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleMedium),
              Text(
                speciality,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: AppColors.grey500),
              ),
              SizedBox(height: 1),
              Row(
                children: [
                  Icon(
                    Icons.medical_information,
                    size: 14,
                    color: Colors.yellow.shade700,
                  ),
                  SizedBox(width: 5),
                  Text(
                    experienceInYears,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
