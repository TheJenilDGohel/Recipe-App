import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/core/network/connectivity_provider.dart';
import '../../data/repositories/recipe_repository_impl.dart';
import '../../domain/models/meal.dart';

part 'recipe_details_provider.g.dart';

@riverpod
Future<Meal?> mealDetails(MealDetailsRef ref, String id) {
  // Watch connectivity status to trigger a re-fetch when connection is restored
  ref.watch(connectivityStatusProvider);
  return ref.watch(recipeRepositoryProvider).getMealDetails(id);
}
