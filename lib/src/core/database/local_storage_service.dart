import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';
import '../../features/recipes/domain/models/meal.dart';

part 'local_storage_service.g.dart';

class LocalStorageService {
  LocalStorageService(this._db);

  final AppDatabase _db;

  Future<void> saveMeal(Meal meal) async {
    final ingredientsJson = jsonEncode(
      meal.ingredients.map((e) => e.toJson()).toList(),
    );

    await _db.into(_db.meals).insertOnConflictUpdate(
          MealsCompanion.insert(
            id: meal.id,
            name: meal.name,
            category: Value(meal.category),
            area: Value(meal.area),
            instructions: Value(meal.instructions),
            thumbnailUrl: Value(meal.thumbnailUrl),
            ingredientsJson: ingredientsJson,
            cachedAt: DateTime.now(),
          ),
        );
  }

  Future<(Meal meal, DateTime cachedAt)?> getMeal(String id) async {
    final query = _db.select(_db.meals)..where((t) => t.id.equals(id));
    final result = await query.getSingleOrNull();

    if (result == null) return null;

    final meal = _mapMealDataToMeal(result);
    return (meal, result.cachedAt);
  }

  Future<void> cacheMeals(List<Meal> meals) async {
    final companions = meals.map((meal) {
      return MealsCompanion.insert(
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
      );
    }).toList();

    await _db.batch((batch) {
      for (final companion in companions) {
        batch.insert(_db.meals, companion, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<List<Meal>> getCachedMeals(String query) async {
    final dbQuery = _db.select(_db.meals)
      ..where((t) => t.name.contains(query) | t.category.contains(query));
    final results = await dbQuery.get();

    return results.map(_mapMealDataToMeal).toList();
  }

  Future<List<Meal>> getMealsByArea(String area) async {
    final dbQuery = _db.select(_db.meals)..where((t) => t.area.equals(area));
    final results = await dbQuery.get();
    return results.map(_mapMealDataToMeal).toList();
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
    final dbQuery = _db.select(_db.meals)..where((t) => t.category.equals(category));
    final results = await dbQuery.get();
    return results.map(_mapMealDataToMeal).toList();
  }

  Future<void> toggleFavorite(String mealId) async {
    final query = _db.select(_db.favorites)..where((t) => t.mealId.equals(mealId));
    final existing = await query.getSingleOrNull();

    if (existing != null) {
      await (_db.delete(_db.favorites)..where((t) => t.mealId.equals(mealId))).go();
    } else {
      await _db.into(_db.favorites).insert(FavoritesCompanion.insert(mealId: mealId));
    }
  }

  Future<bool> isFavorite(String mealId) async {
    final query = _db.select(_db.favorites)..where((t) => t.mealId.equals(mealId));
    final existing = await query.getSingleOrNull();
    return existing != null;
  }

  Future<List<Meal>> getFavorites() async {
    final query = _db.select(_db.meals).join([
      innerJoin(_db.favorites, _db.favorites.mealId.equalsExp(_db.meals.id)),
    ]);

    final results = await query.get();
    
    return results.map((row) {
      return _mapMealDataToMeal(row.readTable(_db.meals));
    }).toList();
  }

  static Meal _mapMealDataToMeal(MealData data) {
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
LocalStorageService localStorageService(LocalStorageServiceRef ref) {
  return LocalStorageService(ref.watch(appDatabaseProvider));
}
