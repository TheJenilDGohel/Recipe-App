import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/services/notification_service.dart';
import 'package:recipe_app/src/core/widgets/offline_banner.dart';
import 'package:recipe_app/src/core/theme/app_theme.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Enable 120Hz/High Refresh Rate on supported Android devices
  if (Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
    } catch (_) {
      // Fallback for devices without high refresh rate support
    }
  }

  final container = ProviderContainer();
  
  try {
    final notificationService = container.read(notificationServiceProvider);
    await notificationService.init().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Notification Service initialization failed: $e');
  }

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
