import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_app/src/core/services/location_service.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';
import 'package:recipe_app/src/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipe_app/src/features/recipes/presentation/providers/contextual_discovery_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}
class MockLocationService extends Mock implements LocationService {}
class MockPosition extends Mock implements Position {}

void main() {
  late MockRecipeRepository mockRepository;
  late MockLocationService mockLocationService;

  setUp(() {
    mockRepository = MockRecipeRepository();
    mockLocationService = MockLocationService();
  });

  ProviderContainer createContainer({DateTime? time}) {
    return ProviderContainer(
      overrides: [
        recipeRepositoryProvider.overrideWith((ref) => mockRepository),
        locationServiceProvider.overrideWith((ref) => mockLocationService),
        if (time != null) currentTimeProvider.overrideWithValue(time),
      ],
    );
  }

  final List<Meal> mockMeals = [
    const Meal(
      id: '1',
      name: 'Test Meal',
      category: 'Test',
      area: 'Test',
      instructions: 'Test',
      thumbnailUrl: '',
    )
  ];

  test('8 AM returns Breakfast category recipes', () async {
    when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => null);
    when(() => mockRepository.filterByCategory('Breakfast')).thenAnswer((_) async => mockMeals);

    final container = createContainer(time: DateTime(2024, 1, 1, 8, 0));
    final result = await container.read(contextualDiscoveryProvider.future);

    expect(result, mockMeals);
    verify(() => mockRepository.filterByCategory('Breakfast')).called(1);
  });

  test('1 PM returns Pasta category recipes', () async {
    when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => null);
    when(() => mockRepository.filterByCategory('Pasta')).thenAnswer((_) async => mockMeals);

    final container = createContainer(time: DateTime(2024, 1, 1, 13, 0));
    final result = await container.read(contextualDiscoveryProvider.future);

    expect(result, mockMeals);
    verify(() => mockRepository.filterByCategory('Pasta')).called(1);
  });

  test('7 PM returns Beef category recipes', () async {
    when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => null);
    when(() => mockRepository.filterByCategory('Beef')).thenAnswer((_) async => mockMeals);

    final container = createContainer(time: DateTime(2024, 1, 1, 19, 0));
    final result = await container.read(contextualDiscoveryProvider.future);

    expect(result, mockMeals);
    verify(() => mockRepository.filterByCategory('Beef')).called(1);
  });

  test('Location "India" returns Indian area recipes', () async {
    final mockPos = MockPosition();
    when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => mockPos);
    when(() => mockLocationService.getCountryFromPosition(mockPos)).thenAnswer((_) async => 'India');
    // Location overrides time or time could be used as fallback. Wait, behavior says:
    // If location is available and maps to a known TheMealDB Area prioritize that area.
    when(() => mockRepository.filterByArea('Indian')).thenAnswer((_) async => mockMeals);

    final container = createContainer(time: DateTime(2024, 1, 1, 8, 0));
    final result = await container.read(contextualDiscoveryProvider.future);

    expect(result, mockMeals);
    verify(() => mockRepository.filterByArea('Indian')).called(1);
  });

  test('Location "Unknown" returns fallback time category (Dessert)', () async {
    final mockPos = MockPosition();
    when(() => mockLocationService.getCurrentPosition()).thenAnswer((_) async => mockPos);
    when(() => mockLocationService.getCountryFromPosition(mockPos)).thenAnswer((_) async => 'UnknownCountry');
    when(() => mockRepository.filterByCategory('Dessert')).thenAnswer((_) async => mockMeals);

    // Night time (fallback time category is Dessert too)
    final container = createContainer(time: DateTime(2024, 1, 1, 23, 0));
    final result = await container.read(contextualDiscoveryProvider.future);

    expect(result, mockMeals);
    verify(() => mockRepository.filterByCategory('Dessert')).called(1);
  });
}
