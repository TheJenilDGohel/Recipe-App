import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/widgets/empty_state.dart';
import 'package:recipe_app/src/core/widgets/error_view.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/search_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_shimmer.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/search_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchRecipesProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Discovery'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const RecipeSearchBar(),
          Expanded(
            child: searchResults.when(
              data: (meals) {
                if (meals.isEmpty) {
                  return EmptyState(
                    title: searchQuery.isEmpty
                        ? 'Search Recipes'
                        : 'No Recipes Found',
                    message: searchQuery.isEmpty
                        ? 'Start searching for delicious recipes!'
                        : 'No recipes found for "$searchQuery". Try another search.',
                    icon: searchQuery.isEmpty ? Icons.search : Icons.search_off,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (context, index) {
                    final meal = meals[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
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
