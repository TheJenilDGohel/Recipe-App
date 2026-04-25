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

  // Debouncing logic
  ref.keepAlive();
  Timer? timer;

  ref.onDispose(() {
    timer?.cancel();
  });

  // Create a completer to handle the async result after debounce
  final completer = Completer<List<Meal>>();

  // Capture the repository before the timer
  final repository = ref.read(recipeRepositoryProvider);

  timer = Timer(const Duration(milliseconds: 500), () async {
    try {
      final results = await repository.searchMeals(query);
      if (!completer.isCompleted) {
        completer.complete(results);
      }
    } catch (e, st) {
      if (!completer.isCompleted) {
        completer.completeError(e, st);
      }
    }
  });

  return completer.future;
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}
