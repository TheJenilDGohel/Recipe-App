import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../domain/models/meal.dart';

part 'favorites_provider.g.dart';

@riverpod
class Favorites extends _$Favorites {
  @override
  Future<List<Meal>> build() {
    return ref.watch(recipeRepositoryProvider).getFavorites();
  }

  Future<void> toggleFavorite(Meal meal) async {
    final repository = ref.read(recipeRepositoryProvider);
    final previousState = state;
    
    // OPTIMISTIC UI: Update state immediately
    state.whenData((currentFavorites) {
      final isFav = currentFavorites.any((m) => m.id == meal.id);
      if (isFav) {
        state = AsyncData(currentFavorites.where((m) => m.id != meal.id).toList());
      } else {
        state = AsyncData([...currentFavorites, meal]);
      }
    });

    try {
      // Ensure the meal is saved to local DB so the reference works
      // We don't await this if it's already cached, but saveMeal is fast anyway
      await repository.getMealDetails(meal.id); 
      
      await repository.toggleFavorite(meal.id);
      
      // We don't invalidateSelf here because we've already updated the state optimistically.
      // But we should refresh from DB to ensure sync.
      final freshFavorites = await repository.getFavorites();
      state = AsyncData(freshFavorites);
    } catch (e) {
      // Rollback on error
      state = previousState;
      rethrow;
    }
  }
}

@riverpod
bool isFavorite(IsFavoriteRef ref, String mealId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.maybeWhen(
    data: (list) => list.any((m) => m.id == mealId),
    orElse: () => false,
  );
}
