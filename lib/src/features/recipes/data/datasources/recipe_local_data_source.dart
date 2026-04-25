import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/models/meal.dart';

part 'recipe_local_data_source.g.dart';

abstract class RecipeLocalDataSource {
  Future<void> saveMeal(Meal meal);
  Future<(Meal meal, DateTime cachedAt)?> getMeal(String id);
  Future<void> cacheMeals(List<Meal> meals);
  Future<List<Meal>> getCachedMeals(String query);
  Future<void> toggleFavorite(String mealId);
  Future<bool> isFavorite(String mealId);
  Future<List<Meal>> getFavorites();
}

class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  RecipeLocalDataSourceImpl(this._db);

  final AppDatabase _db;

  @override
  Future<void> saveMeal(Meal meal) async {
    await _db.into(_db.meals).insertOnConflictUpdate(
          MealsCompanion.insert(
            id: meal.id,
            name: meal.name,
            category: Value(meal.category),
            area: Value(meal.area),
            instructions: Value(meal.instructions),
            thumbnailUrl: Value(meal.thumbnailUrl),
            ingredientsJson: jsonEncode(
              meal.ingredients.map((e) => e.toJson()).toList(),
            ),
            cachedAt: DateTime.now(),
          ),
        );
  }

  @override
  Future<(Meal meal, DateTime cachedAt)?> getMeal(String id) async {
    final query = _db.select(_db.meals)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();

    if (result == null) return null;

    return (_mapToMeal(result), result.cachedAt);
  }

  @override
  Future<void> cacheMeals(List<Meal> meals) async {
    await _db.batch((batch) {
      for (final meal in meals) {
        batch.insert(
          _db.meals,
          MealsCompanion.insert(
            id: meal.id,
            name: meal.name,
            category: Value(meal.category),
            area: Value(meal.area),
            instructions: Value(meal.instructions),
            thumbnailUrl: Value(meal.thumbnailUrl),
            ingredientsJson: jsonEncode(
              meal.ingredients.map((e) => e.toJson()).toList(),
            ),
            cachedAt: DateTime.now(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<List<Meal>> getCachedMeals(String query) async {
    final dbQuery = _db.select(_db.meals)
      ..where((t) => t.name.contains(query) | t.category.contains(query));
    final results = await dbQuery.get();

    return results.map(_mapToMeal).toList();
  }

  @override
  Future<void> toggleFavorite(String mealId) async {
    final query = _db.select(_db.favorites)..where((t) => t.mealId.equals(mealId));
    final existing = await query.getSingleOrNull();

    if (existing != null) {
      await (_db.delete(_db.favorites)..where((t) => t.mealId.equals(mealId))).go();
    } else {
      await _db.into(_db.favorites).insert(FavoritesCompanion.insert(mealId: mealId));
    }
  }

  @override
  Future<bool> isFavorite(String mealId) async {
    final query = _db.select(_db.favorites)..where((t) => t.mealId.equals(mealId));
    final existing = await query.getSingleOrNull();
    return existing != null;
  }

  @override
  Future<List<Meal>> getFavorites() async {
    final query = _db.select(_db.meals).join([
      innerJoin(_db.favorites, _db.favorites.mealId.equalsExp(_db.meals.id)),
    ]);

    final results = await query.get();
    return results.map((row) => _mapToMeal(row.readTable(_db.meals))).toList();
  }

  Meal _mapToMeal(MealData data) {
    final ingredientsList = jsonDecode(data.ingredientsJson) as List;
    final ingredients = ingredientsList
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();

    return Meal(
      id: data.id,
      name: data.name,
      category: data.category ?? '',
      area: data.area ?? '',
      instructions: data.instructions ?? '',
      thumbnailUrl: data.thumbnailUrl ?? '',
      ingredients: ingredients,
    );
  }
}

@riverpod
RecipeLocalDataSource recipeLocalDataSource(RecipeLocalDataSourceRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return RecipeLocalDataSourceImpl(db);
}
