import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:recipe_app/src/core/services/notification_service.dart';
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

import 'package:recipe_app/src/core/services/settings_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unawaited(_checkLocationPermission());
      unawaited(_scheduleReminders());
    });
  }

  Future<void> _scheduleReminders() async {
    final settings = await ref.read(settingsServiceProvider.future);
    final service = ref.read(notificationServiceProvider);
    
    if (settings.isRemindersPromptShown()) {
      return;
    }

    // Show informative dialog FIRST
    final shouldRequest = await _showPermissionInfoDialog(
      title: 'Meal Reminders',
      content: 'Would you like to receive suggestions for Breakfast, Lunch, and Dinner? We can send you a notification at meal times.',
      icon: Icons.notifications_active_rounded,
    );

    await settings.setRemindersPromptShown(true);

    if (shouldRequest) {
      final granted = await service.requestPermissions();
      if (granted) {
        await service.scheduleMealReminders();
      }
    }
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
      final settings = await ref.read(settingsServiceProvider.future);
      if (settings.isRemindersPromptShown()) {
        // Use the same flag or another one for location. 
        // For now, let's just avoid double dialogs on first run.
        return;
      }

      // Show informative dialog FIRST
      final shouldRequest = await _showPermissionInfoDialog(
        title: 'Local Cuisines',
        content: 'Discover recipes popular in your region! Enable location to get personalized local suggestions.',
        icon: Icons.location_on_rounded,
      );

      if (shouldRequest) {
        permission = await Geolocator.requestPermission();
      } else {
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Don't show this automatically on every visit if already denied
      return;
    }
    
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      ref.invalidate(contextualDiscoveryProvider);
      ref.invalidate(contextualDiscoverySubtitleProvider);
    }
  }

  Future<bool> _showPermissionInfoDialog({
    required String title,
    required String content,
    required IconData icon,
  }) async {
    if (!mounted) return false;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('I\'m Interested'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchRecipesProvider(searchQuery));
    final trendingResults = ref.watch(trendingRecipesProvider);

    return Scaffold(
      body: searchResults.when(
        data: (meals) {
          if (meals.isEmpty && searchQuery.isNotEmpty) {
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                const SliverToBoxAdapter(child: RecipeSearchBar()),
                SliverFillRemaining(
                  child: EmptyState(
                    title: 'No Recipes Found',
                    message: 'No recipes found for "$searchQuery". Try another search.',
                    icon: Icons.search_off_rounded,
                  ),
                ),
              ],
            );
          }

          return AnimationLimiter(
            child: CustomScrollView(
              slivers: [
                _buildSliverAppBar(context),
                const SliverToBoxAdapter(child: RecipeSearchBar()),
                
                if (searchQuery.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final meal = meals[index];
                          final heroTag = 'meal-${meal.id}-search';
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: RecipeCard(
                                    meal: meal,
                                    heroTag: heroTag,
                                    onTap: () => _navigateToDetail(context, meal.id, heroTag),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: meals.length,
                      ),
                    ),
                  )
                else ...[
                  const SliverToBoxAdapter(child: ContextualCarousel()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        'Recommendations',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  trendingResults.when(
                    data: (trending) => SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final meal = trending[index];
                            final heroTag = 'meal-${meal.id}-trending';
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: RecipeCard(
                                      meal: meal,
                                      heroTag: heroTag,
                                      onTap: () => _navigateToDetail(context, meal.id, heroTag),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: trending.length,
                        ),
                      ),
                    ),
                    loading: () => const SliverToBoxAdapter(child: RecipeListShimmer()),
                    error: (err, _) => SliverToBoxAdapter(child: ErrorView(message: err.toString())),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
        loading: () => CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            const SliverToBoxAdapter(child: RecipeSearchBar()),
            const SliverToBoxAdapter(child: RecipeListShimmer()),
          ],
        ),
        error: (error, stack) => CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            const SliverToBoxAdapter(child: RecipeSearchBar()),
            SliverFillRemaining(
              child: ErrorView(
                message: error.toString(),
                onRetry: () => ref.refresh(searchRecipesProvider(searchQuery)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar.large(
      title: const Text('DISCOVER'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(Icons.favorite_outline_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, String mealId, String heroTag) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(
          mealId: mealId,
          heroTag: heroTag,
        ),
      ),
    );
  }
}
