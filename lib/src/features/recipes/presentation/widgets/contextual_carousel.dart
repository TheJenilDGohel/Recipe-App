import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/theme/app_colors.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/contextual_discovery_provider.dart';
import 'package:recipe_app/src/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:recipe_app/src/features/recipes/presentation/widgets/mini_recipe_card.dart';
import 'package:shimmer/shimmer.dart';

class ContextualCarousel extends ConsumerWidget {
  const ContextualCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleAsync = ref.watch(contextualDiscoveryTitleProvider);
    final subtitleAsync = ref.watch(contextualDiscoverySubtitleProvider);
    final mealsAsync = ref.watch(contextualDiscoveryProvider);

    if (mealsAsync.isLoading) {
      return const _CarouselShimmer();
    }

    if (mealsAsync.hasError || (mealsAsync.hasValue && mealsAsync.value!.isEmpty)) {
      return const SizedBox.shrink();
    }

    final meals = mealsAsync.value!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: titleAsync.when(
              data: (title) => Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              loading: () => const SizedBox(height: 28),
              error: (error, stack) => const SizedBox(height: 28),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: subtitleAsync.when(
              data: (subtitle) => Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              loading: () => const SizedBox(height: 16),
              error: (error, stack) => const SizedBox(height: 16),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                final heroTag = 'meal-${meal.id}-carousel';
                return MiniRecipeCard(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselShimmer extends StatelessWidget {
  const _CarouselShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 200, height: 28, color: Colors.white),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(width: 120, height: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 216,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: 3,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
