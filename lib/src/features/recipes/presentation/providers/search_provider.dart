import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'dart:async';

part 'search_provider.g.dart';

@riverpod
Future<List<Meal>> searchRecipes(SearchRecipesRef ref, String query) async {
  if (query.isEmpty) {
    return [];
  }

  // Use a Completer to handle the delayed result
  final completer = Completer<List<Meal>>();

  // Create a timer for debouncing
  final timer = Timer(const Duration(milliseconds: 500), () async {
    try {
      final repository = ref.read(recipeRepositoryProvider);
      final results = await repository.searchMeals(query);

      // Only keep alive after a successful fetch
      ref.keepAlive();

      if (!completer.isCompleted) {
        completer.complete(results);
      }
    } catch (e, st) {
      if (!completer.isCompleted) {
        completer.completeError(e, st);
      }
    }
  });

  // Important: cancel the timer if the provider is disposed (e.g., query changed)
  ref.onDispose(() {
    timer.cancel();
  });

  return completer.future;
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}
