import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/widgets/error_view.dart';
import '../providers/recipe_details_provider.dart';
import '../widgets/recipe_shimmer.dart';
import '../widgets/favorite_toggle.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({
    super.key,
    required this.mealId,
  });

  final String mealId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(mealDetailsProvider(mealId));

    return Scaffold(
      body: detailAsync.when(
        data: (meal) {
          if (meal == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('Meal not found')),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                actions: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: FavoriteToggle(meal: meal),
                  ),
                  const SizedBox(width: 8),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    meal.name,
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                    ),
                  ),
                  background: Hero(
                    tag: 'meal-${meal.id}',
                    child: CachedNetworkImage(
                      imageUrl: meal.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        Chip(label: Text(meal.category)),
                        const SizedBox(width: 8),
                        Chip(label: Text(meal.area)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ingredients',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...meal.ingredients.map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${ingredient.measure} ${ingredient.name}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    Text(
                      'Instructions',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal.instructions,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          );
        },
        loading: () => const RecipeDetailShimmer(),
        error: (error, stack) => Scaffold(
          appBar: AppBar(),
          body: ErrorView(
            message: error.toString(),
            onRetry: () => ref.refresh(mealDetailsProvider(mealId)),
          ),
        ),
      ),
    );
  }
}
