import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/search_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/recipe_card.dart';
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
                  return Center(
                    child: Text(
                      searchQuery.isEmpty
                          ? 'Start searching for delicious recipes!'
                          : 'No recipes found for "$searchQuery"',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
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
                          // TODO: Navigate to details
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
