import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

abstract class RecipeRepository {
  Future<List<Meal>> searchMeals(String query);
  Future<Meal?> getMealDetails(String id);
  Future<Meal?> getRandomMeal();
  Future<void> toggleFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
  Future<List<Meal>> getFavorites();
}
