import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/core/network/api_service.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

part 'recipe_remote_data_source.g.dart';

abstract class RecipeRemoteDataSource {
  Future<List<Meal>> searchMeals(String query);
  Future<Meal?> getMealDetails(String id);
  Future<Meal?> getRandomMeal();
  Future<List<Meal>> filterByArea(String area);
  Future<List<Meal>> filterByCategory(String category);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  RecipeRemoteDataSourceImpl(this._api);

  final ApiService _api;

  @override
  Future<List<Meal>> searchMeals(String query) async {
    return _api.get(
      path: 'search.php',
      queryParameters: {'s': query},
      mapper: _mapToMealList,
    );
  }

  @override
  Future<Meal?> getMealDetails(String id) async {
    return _api.get(
      path: 'lookup.php',
      queryParameters: {'i': id},
      mapper: _mapToSingleMeal,
    );
  }

  @override
  Future<Meal?> getRandomMeal() async {
    return _api.get(
      path: 'random.php',
      mapper: _mapToSingleMeal,
    );
  }

  @override
  Future<List<Meal>> filterByArea(String area) async {
    return _api.get(
      path: 'filter.php',
      queryParameters: {'a': area},
      mapper: _mapToMealList,
    );
  }

  @override
  Future<List<Meal>> filterByCategory(String category) async {
    return _api.get(
      path: 'filter.php',
      queryParameters: {'c': category},
      mapper: _mapToMealList,
    );
  }

  static List<Meal> _mapToMealList(dynamic data) {
    final mealsJson = (data as Map<String, dynamic>)['meals'] as List?;
    if (mealsJson == null) return [];
    return mealsJson
        .map((m) => Meal.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  static Meal? _mapToSingleMeal(dynamic data) {
    final mealsJson = (data as Map<String, dynamic>)['meals'] as List?;
    if (mealsJson == null || mealsJson.isEmpty) return null;
    return Meal.fromJson(mealsJson.first as Map<String, dynamic>);
  }
}

@riverpod
RecipeRemoteDataSource recipeRemoteDataSource(RecipeRemoteDataSourceRef ref) {
  return RecipeRemoteDataSourceImpl(ref.watch(apiServiceProvider));
}
