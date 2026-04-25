import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/data/datasources/recipe_local_data_source.dart';
import 'package:recipe_app/src/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/domain/repositories/recipe_repository.dart';

part 'recipe_repository_impl.g.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final RecipeRemoteDataSource _remoteDataSource;
  final RecipeLocalDataSource _localDataSource;

  @override
  Future<List<Meal>> searchMeals(String query) async {
    try {
      final meals = await _remoteDataSource.searchMeals(query);
      await _localDataSource.cacheMeals(meals);
      return meals;
    } catch (_) {
      // Fallback to local cache on error
      return _localDataSource.getCachedMeals(query);
    }
  }

  @override
  Future<Meal?> getMealDetails(String id) async {
    final cached = await _localDataSource.getMeal(id);

    if (cached != null) {
      final (meal, cachedAt) = cached;
      final isExpired =
          DateTime.now().difference(cachedAt) > const Duration(hours: 24);

      if (!isExpired) {
        return meal;
      }
    }

    try {
      final meal = await _remoteDataSource.getMealDetails(id);
      if (meal != null) {
        await _localDataSource.saveMeal(meal);
        return meal;
      }
    } catch (_) {
      // If network fails, return cached even if expired
      if (cached != null) {
        return cached.$1;
      }
    }

    return null;
  }

  @override
  Future<Meal?> getRandomMeal() async {
    try {
      final meal = await _remoteDataSource.getRandomMeal();
      if (meal != null) {
        await _localDataSource.saveMeal(meal);
        return meal;
      }
    } catch (_) {
      // Random meal doesn't have a specific ID to fallback to easily 
      // without more complex logic, but we could return a random one from cache.
      // For now, return null as per current implementation.
    }
    return null;
  }

  @override
  Future<void> toggleFavorite(String mealId) {
    return _localDataSource.toggleFavorite(mealId);
  }

  @override
  Future<bool> isFavorite(String mealId) {
    return _localDataSource.isFavorite(mealId);
  }

  @override
  Future<List<Meal>> getFavorites() {
    return _localDataSource.getFavorites();
  }
}

@riverpod
RecipeRepository recipeRepository(RecipeRepositoryRef ref) {
  return RecipeRepositoryImpl(
    ref.watch(recipeRemoteDataSourceProvider),
    ref.watch(recipeLocalDataSourceProvider),
  );
}

