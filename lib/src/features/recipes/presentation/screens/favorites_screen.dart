import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recipe_app/src/core/providers/permission_provider.dart';
import 'package:recipe_app/src/core/widgets/empty_state.dart';
import 'package:recipe_app/src/core/widgets/error_view.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/favorites_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final locationPermission = ref.watch(locationPermissionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Informative banner for location permission if missing
          locationPermission.maybeWhen(
            data: (status) {
              if (status == LocationPermission.denied || status == LocationPermission.deniedForever) {
                return Container(
                  width: double.infinity,
                  color: Colors.amber.shade50,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Icon(Icons.location_off_rounded, color: Colors.amber.shade900, size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Location disabled. Discovery is limited to global trends.',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                      TextButton(
                        onPressed: () => ref.read(locationPermissionStatusProvider.notifier).request(),
                        child: const Text('ENABLE'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
          Expanded(
            child: favoritesAsync.when(
              data: (meals) {
                if (meals.isEmpty) {
                  return EmptyState(
                    title: 'Your Cookbook is Empty',
                    message: 'Save recipes to access them even without internet.',
                    icon: Icons.favorite_border,
                    actionLabel: 'Explore Recipes',
                    onAction: () {
                      Navigator.of(context).pop();
                    },
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    final heroTag = 'meal-${meal.id}-favorites';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: RecipeCard(
                        meal: meal,
                        heroTag: heroTag,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(
                                mealId: meal.id,
                                heroTag: heroTag,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(favoritesProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
