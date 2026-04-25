import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

void main() {
  group('Meal Model', () {
    test('fromJson should correctly parse ingredients and measures', () {
      final json = {
        'idMeal': '52772',
        'strMeal': 'Teriyaki Chicken Casserole',
        'strCategory': 'Chicken',
        'strArea': 'Japanese',
        'strInstructions': 'Instructions here...',
        'strMealThumb': 'https://www.themealdb.com/images/media/meals/wvpsxx1468256321.jpg',
        'strTags': 'Meat,Casserole',
        'strYoutube': 'https://www.youtube.com/watch?v=4aZr5hZXP_s',
        'strIngredient1': 'soy sauce',
        'strIngredient2': 'water',
        'strIngredient3': 'brown sugar',
        'strIngredient4': '', // Empty ingredient
        'strIngredient5': null, // Null ingredient
        'strMeasure1': '3/4 cup',
        'strMeasure2': '1/2 cup',
        'strMeasure3': '1/4 cup',
        'strMeasure4': '',
        'strMeasure5': null,
      };

      final meal = Meal.fromJson(json);

      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.ingredients.length, 3);
      expect(meal.ingredients[0].name, 'soy sauce');
      expect(meal.ingredients[0].measure, '3/4 cup');
    });
  });
}
