import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/services/notification_service.dart';
import 'package:recipe_app/src/core/widgets/offline_banner.dart';
import 'package:recipe_app/src/core/theme/app_theme.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final notificationService = container.read(notificationServiceProvider);
  await notificationService.init();
  // Request permissions on startup as per ENG-02
  await notificationService.requestPermissions();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        return Column(
          children: [
            const OfflineBanner(),
            Expanded(child: child!),
          ],
        );
      },
      home: const HomeScreen(),
    );
  }
}
