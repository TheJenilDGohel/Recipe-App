import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

abstract class RecipeRepository {
  Future<List<Meal>> searchMeals(String query);
  Future<Meal?> getMealDetails(String id);
  Future<Meal?> getRandomMeal();
}
