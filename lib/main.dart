import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/widgets/offline_banner.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
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
