import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_app/src/core/theme/app_colors.dart';
import 'package:recipe_app/src/core/widgets/error_view.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import '../providers/recipe_details_provider.dart';
import '../widgets/recipe_shimmer.dart';
import '../widgets/favorite_toggle.dart';

class RecipeDetailScreen extends ConsumerWidget {
  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    this.heroTag,
  });

  final String mealId;
  final String? heroTag;

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

          final effectiveHeroTag = heroTag ?? 'meal-${meal.id}';

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                stretch: true,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: FavoriteToggle(meal: meal),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Hero(
                    tag: effectiveHeroTag,
                    child: CachedNetworkImage(
                      imageUrl: meal.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTag(context, meal.category),
                            const SizedBox(width: 12),
                            _buildTag(context, meal.area, isSecondary: true),
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'Ingredients'),
                        const SizedBox(height: 16),
                        _buildIngredientsList(context, meal),
                        const SizedBox(height: 32),
                        _buildSectionTitle(context, 'Instructions'),
                        const SizedBox(height: 16),
                        _buildInstructions(context, meal),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
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

  Widget _buildTag(BuildContext context, String label, {bool isSecondary = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSecondary 
          ? Colors.white 
          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: isSecondary ? Border.all(color: AppColors.border) : null,
      ),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: isSecondary ? AppColors.textSecondary : Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  Widget _buildIngredientsList(BuildContext context, Meal meal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: meal.ingredients.length,
        separatorBuilder: (context, index) => const Divider(height: 24, color: AppColors.divider),
        itemBuilder: (context, index) {
          final ingredient = meal.ingredients[index];
          return Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  ingredient.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                ingredient.measure,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstructions(BuildContext context, Meal meal) {
    final List<String> instructions = meal.instructions.split('\n').where((s) => s.trim().isNotEmpty).toList();
    
    return Column(
      children: instructions.map<Widget>((step) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  step.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
