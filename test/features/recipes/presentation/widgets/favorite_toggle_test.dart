import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/favorite_toggle.dart';

void main() {
  testWidgets('FavoriteToggle renders correctly', (tester) async {
    const meal = Meal(
      id: '1',
      name: 'Test Meal',
      category: 'Test',
      area: 'Test',
      instructions: 'Test',
      thumbnailUrl: 'Test',
      ingredients: [],
    );

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FavoriteToggle(meal: meal),
          ),
        ),
      ),
    );

    expect(find.byType(FavoriteToggle), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
