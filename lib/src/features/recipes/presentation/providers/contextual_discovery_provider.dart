import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/core/services/location_service.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

part 'contextual_discovery_provider.g.dart';

@riverpod
DateTime currentTime(CurrentTimeRef ref) {
  return DateTime.now();
}

String _getCategoryForTime(DateTime time) {
  final hour = time.hour;
  if (hour >= 6 && hour <= 10) return 'Breakfast';
  if (hour >= 11 && hour <= 14) return 'Pasta';
  if (hour >= 17 && hour <= 21) return 'Beef';
  return 'Dessert';
}

String? _getAreaForCountry(String country) {
  final map = {
    'United States': 'American',
    'United Kingdom': 'British',
    'Canada': 'British',
    'India': 'Indian',
    'China': 'Chinese',
    'Japan': 'Chinese',
    'Italy': 'Italian',
    'Mexico': 'Mexican',
    'France': 'Italian', // Simplified fallback
    'Spain': 'Spanish',
    'Thailand': 'Thai',
  };
  return map[country];
}

@riverpod
Future<List<Meal>> contextualDiscovery(ContextualDiscoveryRef ref) async {
  final repo = ref.watch(recipeRepositoryProvider);
  final locationService = ref.watch(locationServiceProvider);
  final time = ref.watch(currentTimeProvider);

  try {
    final pos = await locationService.getCurrentPosition();
    if (pos != null) {
      final country = await locationService.getCountryFromPosition(pos);
      if (country != null) {
        final area = _getAreaForCountry(country);
        if (area != null) {
          return await repo.filterByArea(area);
        }
      }
    }
  } catch (_) {
    // Fallback to time-based on error
  }

  // Fallback to time-based discovery
  final category = _getCategoryForTime(time);
  return await repo.filterByCategory(category);
}

@riverpod
Future<String> contextualDiscoveryTitle(ContextualDiscoveryTitleRef ref) async {
  final time = ref.watch(currentTimeProvider);
  final hour = time.hour;
  if (hour >= 6 && hour <= 10) return 'Good Morning!';
  if (hour >= 11 && hour <= 14) return 'Time for Lunch';
  if (hour >= 17 && hour <= 21) return 'Dinner Ideas';
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
    // Ignore error
  }
  return 'Trending Globally';
}
