import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_field.dart';


class LabeledTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final IconData? suffixIcon;
  final TextEditingController? controller;

  const LabeledTextField({
    super.key,
    required this.title,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.suffixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        AppTextField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          obscureText: obscureText,
          isPassword: isPassword,
          suffixIcon: suffixIcon,
        ),
      ],
    );
  }
}