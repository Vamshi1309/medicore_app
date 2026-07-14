import 'package:flutter/material.dart';
import 'package:frontend/core/constants/app_sizes.dart';
import 'package:frontend/core/theme/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: AppSizes.md),
          if (message != null)
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
