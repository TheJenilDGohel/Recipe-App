import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/local_storage_service.dart';
import '../../domain/models/meal.dart';

part 'recipe_local_data_source.g.dart';

abstract class RecipeLocalDataSource {
  Future<void> saveMeal(Meal meal);
  Future<(Meal meal, DateTime cachedAt)?> getMeal(String id);
  Future<void> cacheMeals(List<Meal> meals);
  Future<List<Meal>> getCachedMeals(String query);
  Future<List<Meal>> getMealsByArea(String area);
  Future<List<Meal>> getMealsByCategory(String category);
  Future<void> toggleFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
  Future<List<Meal>> getFavorites();
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  RecipeLocalDataSourceImpl(this._storage);

  final LocalStorageService _storage;

  @override
  Future<void> saveMeal(Meal meal) => _storage.saveMeal(meal);

  @override
  Future<(Meal meal, DateTime cachedAt)?> getMeal(String id) => _storage.getMeal(id);

  @override
  Future<void> cacheMeals(List<Meal> meals) => _storage.cacheMeals(meals);

  @override
  Future<List<Meal>> getCachedMeals(String query) => _storage.getCachedMeals(query);

  @override
  Future<List<Meal>> getMealsByArea(String area) => _storage.getMealsByArea(area);

  @override
  Future<List<Meal>> getMealsByCategory(String category) => _storage.getMealsByCategory(category);

  @override
  Future<void> toggleFavorite(String mealId) => _storage.toggleFavorite(mealId);

  @override
  Future<bool> isFavorite(String mealId) => _storage.isFavorite(mealId);

  @override
  Future<List<Meal>> getFavorites() => _storage.getFavorites();
}

@riverpod
RecipeLocalDataSource recipeLocalDataSource(RecipeLocalDataSourceRef ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return RecipeLocalDataSourceImpl(storage);
}
