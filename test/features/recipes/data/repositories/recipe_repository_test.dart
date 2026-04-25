import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_app/src/features/recipes/data/datasources/recipe_local_data_source.dart';
import 'package:recipe_app/src/features/recipes/data/datasources/recipe_remote_data_source.dart';
import 'package:recipe_app/src/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipe_app/src/features/recipes/domain/models/meal.dart';

class MockRemoteDataSource extends Mock implements RecipeRemoteDataSource {}
class MockLocalDataSource extends Mock implements RecipeLocalDataSource {}

class MealFake extends Fake implements Meal {}

void main() {
  late RecipeRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUpAll(() {
    registerFallbackValue(MealFake());
  });

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    repository = RecipeRepositoryImpl(mockRemote, mockLocal);
  });

  const tMeal = Meal(
    id: '1',
    name: 'Test Meal',
    category: 'Test',
    area: 'Test',
    instructions: 'Test',
    thumbnailUrl: 'Test',
    ingredients: [],
  );

  group('getMealDetails', () {
    test('should return cached meal when it is not expired', () async {
      // arrange
      final cachedAt = DateTime.now().subtract(const Duration(hours: 12));
      when(() => mockLocal.getMeal(any()))
          .thenAnswer((_) async => (tMeal, cachedAt));

      // act
      final result = await repository.getMealDetails('1');

      // assert
      expect(result, equals(tMeal));
      verify(() => mockLocal.getMeal('1'));
      verifyNoMoreInteractions(mockRemote);
    });

    test('should fetch from remote when cache is expired', () async {
      // arrange
      final cachedAt = DateTime.now().subtract(const Duration(hours: 25));
      when(() => mockLocal.getMeal(any()))
          .thenAnswer((_) async => (tMeal, cachedAt));
      when(() => mockRemote.getMealDetails(any()))
          .thenAnswer((_) async => tMeal);
      when(() => mockLocal.saveMeal(any())).thenAnswer((_) async {});

      // act
      final result = await repository.getMealDetails('1');

      // assert
      expect(result, equals(tMeal));
      verify(() => mockLocal.getMeal('1'));
      verify(() => mockRemote.getMealDetails('1'));
      verify(() => mockLocal.saveMeal(tMeal));
    });

    test('should return cached meal when remote fails even if expired', () async {
      // arrange
      final cachedAt = DateTime.now().subtract(const Duration(hours: 25));
      when(() => mockLocal.getMeal(any()))
          .thenAnswer((_) async => (tMeal, cachedAt));
      when(() => mockRemote.getMealDetails(any())).thenThrow(Exception());

      // act
      final result = await repository.getMealDetails('1');

      // assert
      expect(result, equals(tMeal));
      verify(() => mockLocal.getMeal('1'));
      verify(() => mockRemote.getMealDetails('1'));
    });
  });

  group('searchMeals', () {
    test('should return remote results and cache them', () async {
      // arrange
      when(() => mockRemote.searchMeals(any()))
          .thenAnswer((_) async => [tMeal]);
      when(() => mockLocal.cacheMeals(any())).thenAnswer((_) async {});

      // act
      final result = await repository.searchMeals('test');

      // assert
      expect(result, equals([tMeal]));
      verify(() => mockRemote.searchMeals('test'));
      verify(() => mockLocal.cacheMeals([tMeal]));
    });

    test('should return cached results when remote fails', () async {
      // arrange
      when(() => mockRemote.searchMeals(any())).thenThrow(Exception());
      when(() => mockLocal.getCachedMeals(any()))
          .thenAnswer((_) async => [tMeal]);

      // act
      final result = await repository.searchMeals('test');

      // assert
      expect(result, equals([tMeal]));
      verify(() => mockRemote.searchMeals('test'));
      verify(() => mockLocal.getCachedMeals('test'));
    });
  });
}
