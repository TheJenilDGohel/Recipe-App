import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/domain/repositories/recipe_repository.dart';

part 'recipe_repository_impl.g.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._remoteDataSource);

  final RecipeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Meal>> searchMeals(String query) {
    return _remoteDataSource.searchMeals(query);
  }

  @override
  Future<Meal?> getMealDetails(String id) {
    return _remoteDataSource.getMealDetails(id);
  }

  @override
  Future<Meal?> getRandomMeal() {
    return _remoteDataSource.getRandomMeal();
  }
}

@riverpod
RecipeRepository recipeRepository(RecipeRepositoryRef ref) {
  return RecipeRepositoryImpl(ref.watch(recipeRemoteDataSourceProvider));
}
