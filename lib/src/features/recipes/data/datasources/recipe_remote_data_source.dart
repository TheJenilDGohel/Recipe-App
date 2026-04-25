import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/core/network/dio_client.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

part 'recipe_remote_data_source.g.dart';

abstract class RecipeRemoteDataSource {
  Future<List<Meal>> searchMeals(String query);
  Future<Meal?> getMealDetails(String id);
  Future<Meal?> getRandomMeal();
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  RecipeRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<Meal>> searchMeals(String query) async {
    final response = await _dio.get('search.php', queryParameters: {'s': query});
    final data = response.data as Map<String, dynamic>;
    final mealsJson = data['meals'] as List?;
    
    if (mealsJson == null) return [];
    
    return mealsJson
        .map((m) => Meal.fromJson(m as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Meal?> getMealDetails(String id) async {
    final response = await _dio.get('lookup.php', queryParameters: {'i': id});
    final data = response.data as Map<String, dynamic>;
    final mealsJson = data['meals'] as List?;
    
    if (mealsJson == null || mealsJson.isEmpty) return null;
    
    return Meal.fromJson(mealsJson.first as Map<String, dynamic>);
  }

  @override
  Future<Meal?> getRandomMeal() async {
    final response = await _dio.get('random.php');
    final data = response.data as Map<String, dynamic>;
    final mealsJson = data['meals'] as List?;
    
    if (mealsJson == null || mealsJson.isEmpty) return null;
    
    return Meal.fromJson(mealsJson.first as Map<String, dynamic>);
  }
}

@riverpod
RecipeRemoteDataSource recipeRemoteDataSource(RecipeRemoteDataSourceRef ref) {
  return RecipeRemoteDataSourceImpl(ref.watch(dioProvider));
}
