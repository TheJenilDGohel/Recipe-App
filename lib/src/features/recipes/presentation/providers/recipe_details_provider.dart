import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/models/meal.dart';

part 'recipe_details_provider.g.dart';

@riverpod
Future<Meal?> mealDetails(MealDetailsRef ref, String id) {
  return ref.watch(recipeRepositoryProvider).getMealDetails(id);
}
