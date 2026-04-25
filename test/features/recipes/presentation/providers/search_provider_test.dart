import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
  });

  ProviderContainer makeContainer(MockRecipeRepository repository) {
    final container = ProviderContainer(
      overrides: [
        recipeRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('searchRecipesProvider', () {
    test('should return empty list when query is empty', () async {
      final container = makeContainer(mockRepository);
      
      final result = await container.read(searchRecipesProvider('').future);
      
      expect(result, isEmpty);
      verifyNever(() => mockRepository.searchMeals(any()));
    });

    test('should debounce search requests', () async {
      final container = makeContainer(mockRepository);
      final meals = [
        const Meal(
          id: '1',
          name: 'Meal 1',
          category: 'C',
          area: 'A',
          instructions: 'I',
          thumbnailUrl: 'U',
          ingredients: [],
        ),
      ];
      
      when(() => mockRepository.searchMeals('pizza')).thenAnswer((_) async => meals);

      // Trigger search
      final future = container.read(searchRecipesProvider('pizza').future);
      
      // Should not have called repository immediately
      verifyNever(() => mockRepository.searchMeals('pizza'));

      // Wait for debounce (500ms + some margin)
      await Future.delayed(const Duration(milliseconds: 600));
      
      final result = await future;
      
      expect(result, meals);
      verify(() => mockRepository.searchMeals('pizza')).called(1);
    });
  });
}
