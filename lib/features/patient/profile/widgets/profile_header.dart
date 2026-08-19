import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';

/// Gradient header showing an avatar initial, the user's name, and a
/// role/status badge (e.g. "PATIENT").
class ProfileHeader extends StatelessWidget {
  final String name;
  final String role;
  final String? avatarLetter;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.role,
    this.avatarLetter,
  });

  @override
  Widget build(BuildContext context) {
    final letter =
        avatarLetter ?? (name.isNotEmpty ? name[0].toUpperCase() : '?');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0C4BC4), Color(0xFF1A6BFF)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              role.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
