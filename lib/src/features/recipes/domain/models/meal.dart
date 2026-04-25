import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required String measure,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}

@freezed
class Meal with _$Meal {
  const factory Meal({
    required String id,
    required String name,
    required String category,
    required String area,
    required String instructions,
    required String thumbnailUrl,
    String? tags,
    String? youtubeUrl,
    @Default([]) List<Ingredient> ingredients,
  }) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (var i = 1; i <= 20; i++) {
      final name = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (name != null && name.trim().isNotEmpty) {
        ingredients.add(Ingredient(
          name: name.trim(),
          measure: (measure ?? '').trim(),
        ));
      }
    }

    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String,
      area: json['strArea'] as String,
      instructions: json['strInstructions'] as String,
      thumbnailUrl: json['strMealThumb'] as String,
      tags: json['strTags'] as String?,
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }
}
