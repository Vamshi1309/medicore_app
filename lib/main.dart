import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/go_router_provider.dart';
import 'package:frontend/core/startup/app_initializer.dart';
import 'package:frontend/core/theme/app_theme.dart';
import 'package:frontend/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return AppInitializer(
      child: MaterialApp.router(
        title: "MediCore",
        theme: AppTheme.lightTheme,
        routerConfig: router,
      ),
    );
  }
}
