import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../domain/models/meal.dart';

part 'favorites_provider.g.dart';

@riverpod
class Favorites extends _$Favorites {
  @override
  FutureOr<List<Meal>> build() {
    return ref.watch(recipeRepositoryProvider).getFavorites();
  }

  Future<void> toggleFavorite(Meal meal) async {
    final repository = ref.read(recipeRepositoryProvider);
    
    // Ensure the meal is saved to local DB so the reference works
    await repository.getMealDetails(meal.id); 
    
    await repository.toggleFavorite(meal.id);
    ref.invalidateSelf();
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
