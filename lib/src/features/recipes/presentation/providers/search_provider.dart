import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'favorites_provider.dart';

part 'search_provider.g.dart';

@riverpod
Future<List<Meal>> searchRecipes(SearchRecipesRef ref, String query) async {
  if (query.isEmpty) {
    // If query is empty, the home screen shows the carousel + inspiration state.
    return [];
  }

  try {
    // Use the optimized search logic with debouncing.
    // Fixed: Pass query to the provider
    return await ref.watch(debouncedSearchProvider(query).future);
  } catch (_) {
    // STATE RESILIENCE: If network fails during search, try to find matching meals in favorites
    final favorites = ref.read(favoritesProvider).value ?? [];
    final matchingFavorites = favorites
        .where((m) => m.name.toLowerCase().contains(query.toLowerCase()) || 
                      m.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
        
    if (matchingFavorites.isNotEmpty) {
      return matchingFavorites;
    }
    
    // Rethrow to let the UI handle the error (ErrorView)
    rethrow;
  }
}

@riverpod
Future<List<Meal>> debouncedSearch(DebouncedSearchRef ref, String query) async {
  // Wait for debounce period
  await Future.delayed(const Duration(milliseconds: 500));

  // If the provider is disposed during the delay (e.g. query changed), 
  // the execution will stop here because the future will be cancelled by Riverpod.
  
  final repo = ref.watch(recipeRepositoryProvider);
  return await repo.searchMeals(query);
}

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}
