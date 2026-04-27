import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
      _scheduleReminders();
    });
  }

  Future<void> _scheduleReminders() async {
    final service = ref.read(notificationServiceProvider);
    final granted = await service.requestPermissions();
    if (granted) {
      await service.scheduleMealReminders();
    } else {
      _showNotificationDeniedDialog();
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
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _showLocationDeniedDialog();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _showLocationDeniedDialog();
      return;
    }
    
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      ref.invalidate(contextualDiscoveryProvider);
      ref.invalidate(contextualDiscoverySubtitleProvider);
    }
  }

  void _showLocationDeniedDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personalize Your Recipes'),
        content: const Text('Enable location to discover popular cuisines in your region. You can always change this later in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showNotificationDeniedDialog() {
    if (!mounted) return;
    // Show a subtle snackbar or non-intrusive dialog for notifications
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Enable notifications for meal-time recipe ideas!'),
        action: SnackBarAction(
          label: 'Settings',
          onPressed: () => Geolocator.openAppSettings(), // General settings
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResults = ref.watch(searchRecipesProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
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
                    icon: Icons.search_off_rounded,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: meals.length + (searchQuery.isEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (searchQuery.isEmpty && index == 0) {
                      return const ContextualCarousel();
                    }

                    final mealIndex = searchQuery.isEmpty ? index - 1 : index;
                    final meal = meals[mealIndex];
                    final heroTag = 'meal-${meal.id}-home';

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
