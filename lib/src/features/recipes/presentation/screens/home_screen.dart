import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recipe_app/src/core/widgets/empty_state.dart';
import 'package:recipe_app/src/core/widgets/error_view.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/contextual_discovery_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/search_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/favorites_screen.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/contextual_carousel.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_shimmer.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/search_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return;
      }
    }
    
    // If permission granted, refresh the contextual discovery
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      ref.invalidate(contextualDiscoveryProvider);
      ref.invalidate(contextualDiscoverySubtitleProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchRecipesProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Discovery'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const RecipeSearchBar(),
          Expanded(
            child: searchResults.when(
              data: (meals) {
                if (meals.isEmpty && searchQuery.isNotEmpty) {
                  return EmptyState(
                    title: 'No Recipes Found',
                    message: 'No recipes found for "$searchQuery". Try another search.',
                    icon: Icons.search_off,
                  );
                }

                if (meals.isEmpty && searchQuery.isEmpty) {
                  return ListView(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    children: [
                      const ContextualCarousel(),
                      EmptyState(
                        title: 'Search Recipes',
                        message: 'Start searching for delicious recipes!',
                        icon: Icons.search,
                      ),
                    ],
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  itemCount: meals.length + (searchQuery.isEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (searchQuery.isEmpty && index == 0) {
                      return const ContextualCarousel();
                    }

                    final mealIndex = searchQuery.isEmpty ? index - 1 : index;
                    final meal = meals[mealIndex];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                      child: RecipeCard(
                        meal: meal,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RecipeDetailScreen(mealId: meal.id),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const RecipeListShimmer(),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(searchRecipesProvider(searchQuery)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
