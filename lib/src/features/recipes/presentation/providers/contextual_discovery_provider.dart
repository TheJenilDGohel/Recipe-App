import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/core/services/location_service.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

import 'package:recipe_app/src/features/recipes/presentation/providers/favorites_provider.dart';

part 'contextual_discovery_provider.g.dart';

@riverpod
DateTime currentTime(CurrentTimeRef ref) {
  return DateTime.now();
}

String _getCategoryForTime(DateTime time) {
  final hour = time.hour;
  // Breakfast: 5 AM - 10 AM
  if (hour >= 5 && hour <= 10) return 'Breakfast';
  
  // Lunch: 11 AM - 3 PM
  if (hour >= 11 && hour <= 15) {
    final categories = ['Pasta', 'Seafood', 'Vegetarian', 'Chicken'];
    return categories[time.minute % categories.length];
  }
  
  // Dinner: 4 PM - 9 PM
  if (hour >= 16 && hour <= 21) {
    final categories = ['Beef', 'Lamb', 'Pork', 'Side', 'Vegetarian'];
    return categories[time.minute % categories.length];
  }
  
  // Late Night / Early Morning
  return 'Dessert';
}

String? _getAreaForCountry(String country) {
  final map = {
    'United States': 'American',
    'United Kingdom': 'British',
    'Canada': 'Canadian',
    'India': 'Indian',
    'China': 'Chinese',
    'Japan': 'Japanese',
    'Italy': 'Italian',
    'Mexico': 'Mexican',
    'France': 'French',
    'Spain': 'Spanish',
    'Thailand': 'Thai',
    'Vietnam': 'Vietnamese',
    'Malaysia': 'Malaysian',
    'Morocco': 'Moroccan',
    'Greece': 'Greek',
    'Philippines': 'Filipino',
    'Egypt': 'Egyptian',
    'Russia': 'Russian',
    'Poland': 'Polish',
    'Portugal': 'Portuguese',
    'Ireland': 'Irish',
    'Jamaica': 'Jamaican',
    'Kenya': 'Kenyan',
    'Croatia': 'Croatian',
    'Netherlands': 'Dutch',
    'Tunisia': 'Tunisian',
    'Turkey': 'Turkish',
  };
  return map[country];
}

@riverpod
Future<List<Meal>> contextualDiscovery(ContextualDiscoveryRef ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final locationService = ref.watch(locationServiceProvider);
  final time = ref.watch(currentTimeProvider);

  List<Meal> meals = [];

  try {
    // Attempt location-based first
    final pos = await locationService.getCurrentPosition();
    if (pos != null) {
      final country = await locationService.getCountryFromPosition(pos);
      if (country != null) {
        final area = _getAreaForCountry(country);
        if (area != null) {
          meals = await repo.filterByArea(area);
        }
      }
    }
  } catch (_) {
    // Graceful fallback to time-based on any location error or denial
  }

  if (meals.isEmpty) {
    // Fallback to time-based discovery
    final category = _getCategoryForTime(time);
    meals = await repo.filterByCategory(category);
  }

  if (meals.isEmpty) {
    // ULTIMATE FALLBACK: If category is empty (rare for API, but possible), 
    // fetch a few random meals or search for a popular term.
    meals = await repo.searchMeals('Chicken');
  }

  // RANDOMIZE: Shuffle the results so it feels fresh on every visit
  final shuffled = List<Meal>.from(meals)..shuffle();
  return shuffled;
}

@riverpod
Future<String> contextualDiscoveryTitle(ContextualDiscoveryTitleRef ref) async {
  final time = ref.watch(currentTimeProvider);
  final hour = time.hour;
  if (hour >= 5 && hour <= 10) return 'Good Morning!';
  if (hour >= 11 && hour <= 15) return 'Time for Lunch';
  if (hour >= 16 && hour <= 21) return 'Dinner Ideas';
  return 'Late Night Cravings';
}

@riverpod
Future<String> contextualDiscoverySubtitle(ContextualDiscoverySubtitleRef ref) async {
  final locationService = ref.watch(locationServiceProvider);
  try {
    final pos = await locationService.getCurrentPosition();
    if (pos != null) {
      final country = await locationService.getCountryFromPosition(pos);
      if (country != null && _getAreaForCountry(country) != null) {
        return 'Popular in $country';
      }
    }
  } catch (_) {
    // Ignore error, fallback to global
  }
  return 'Trending Globally';
}

@riverpod
Future<List<Meal>> trendingRecipes(TrendingRecipesRef ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final favoritesAsync = ref.watch(favoritesProvider);
  
  List<Meal> recommendations = [];

  // 1. ANALYZE FAVORITES for Personalization
  final favorites = favoritesAsync.value ?? [];
  if (favorites.isNotEmpty) {
    // Count category frequencies
    final categoryCounts = <String, int>{};
    for (final meal in favorites) {
      if (meal.category.isNotEmpty) {
        categoryCounts[meal.category] = (categoryCounts[meal.category] ?? 0) + 1;
      }
    }

    if (categoryCounts.isNotEmpty) {
      // Find the most frequent category
      final topCategory = categoryCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      
      recommendations = await repo.filterByCategory(topCategory);
    }
  }

  // 2. COLD START / NO FAVORITES: Fallback to rotating keywords
  if (recommendations.isEmpty) {
    final keywords = ['Pasta', 'Seafood', 'Vegetarian', 'Chicken', 'Beef', 'Dessert'];
    final now = DateTime.now();
    final keyword = keywords[now.minute % keywords.length];
    recommendations = await repo.searchMeals(keyword);
  }

  // 3. INJECT SERENDIPITY: Add 1 completely random meal to the mix
  try {
    final randomMeal = await repo.getRandomMeal();
    if (randomMeal != null && !recommendations.any((m) => m.id == randomMeal.id)) {
      recommendations.add(randomMeal);
    }
  } catch (_) {
    // Random fail is fine, we still have the list
  }

  // 4. SHUFFLE: Ensure the engine feels dynamic
  final shuffled = List<Meal>.from(recommendations)..shuffle();
  
  return shuffled;
}
