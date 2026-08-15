import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/widgets/app_snackbar.dart';
import 'package:frontend/core/widgets/custom_app_bar.dart';
import 'package:frontend/core/widgets/primary_button.dart';
import 'package:frontend/features/auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  initState() {
    super.initState();

    ref.listenManual(authProvider, (prev, next) {
      if (next.error != null) {
        AppSnackBar.error(context, next.error!);
      }

      if (next.message != null) {
        AppSnackBar.success(context, next.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userRole: ref.watch(authProvider).user?.role.name ?? "No role",
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ref.watch(authProvider).user?.name ?? "No user",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            ref.watch(authProvider).user?.id ?? "No id",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            ref.watch(authProvider).user?.phoneNumber ?? "No phone number",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            ref.watch(authProvider).user?.role.name ?? "No role",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 120),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: PrimaryButton(
                text: "Logout",
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
