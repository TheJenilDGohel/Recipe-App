// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRecipesHash() => r'dc9b3036bd177ea10b16bb650c4c9afbac7c02c3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [searchRecipes].
@ProviderFor(searchRecipes)
const searchRecipesProvider = SearchRecipesFamily();

/// See also [searchRecipes].
class SearchRecipesFamily extends Family<AsyncValue<List<Meal>>> {
  /// See also [searchRecipes].
  const SearchRecipesFamily();

  /// See also [searchRecipes].
  SearchRecipesProvider call(
    String query,
  ) {
    return SearchRecipesProvider(
      query,
    );
  }

  @override
  SearchRecipesProvider getProviderOverride(
    covariant SearchRecipesProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchRecipesProvider';
}

/// See also [searchRecipes].
class SearchRecipesProvider extends AutoDisposeFutureProvider<List<Meal>> {
  /// See also [searchRecipes].
  SearchRecipesProvider(
    String query,
  ) : this._internal(
          (ref) => searchRecipes(
            ref as SearchRecipesRef,
            query,
          ),
          from: searchRecipesProvider,
          name: r'searchRecipesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchRecipesHash,
          dependencies: SearchRecipesFamily._dependencies,
          allTransitiveDependencies:
              SearchRecipesFamily._allTransitiveDependencies,
          query: query,
        );

  SearchRecipesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Meal>> Function(SearchRecipesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchRecipesProvider._internal(
        (ref) => create(ref as SearchRecipesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Meal>> createElement() {
    return _SearchRecipesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchRecipesProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchRecipesRef on AutoDisposeFutureProviderRef<List<Meal>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _SearchRecipesProviderElement
    extends AutoDisposeFutureProviderElement<List<Meal>> with SearchRecipesRef {
  _SearchRecipesProviderElement(super.provider);

  @override
  String get query => (origin as SearchRecipesProvider).query;
}

String _$debouncedSearchHash() => r'b849b763be52c2c738a566157bc551b52e193abd';

/// See also [debouncedSearch].
@ProviderFor(debouncedSearch)
const debouncedSearchProvider = DebouncedSearchFamily();

/// See also [debouncedSearch].
class DebouncedSearchFamily extends Family<AsyncValue<List<Meal>>> {
  /// See also [debouncedSearch].
  const DebouncedSearchFamily();

  /// See also [debouncedSearch].
  DebouncedSearchProvider call(
    String query,
  ) {
    return DebouncedSearchProvider(
      query,
    );
  }

  @override
  DebouncedSearchProvider getProviderOverride(
    covariant DebouncedSearchProvider provider,
  ) {
    return call(
      provider.query,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'debouncedSearchProvider';
}

/// See also [debouncedSearch].
class DebouncedSearchProvider extends AutoDisposeFutureProvider<List<Meal>> {
  /// See also [debouncedSearch].
  DebouncedSearchProvider(
    String query,
  ) : this._internal(
          (ref) => debouncedSearch(
            ref as DebouncedSearchRef,
            query,
          ),
          from: debouncedSearchProvider,
          name: r'debouncedSearchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$debouncedSearchHash,
          dependencies: DebouncedSearchFamily._dependencies,
          allTransitiveDependencies:
              DebouncedSearchFamily._allTransitiveDependencies,
          query: query,
        );

  DebouncedSearchProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    FutureOr<List<Meal>> Function(DebouncedSearchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DebouncedSearchProvider._internal(
        (ref) => create(ref as DebouncedSearchRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Meal>> createElement() {
    return _DebouncedSearchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DebouncedSearchProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DebouncedSearchRef on AutoDisposeFutureProviderRef<List<Meal>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _DebouncedSearchProviderElement
    extends AutoDisposeFutureProviderElement<List<Meal>>
    with DebouncedSearchRef {
  _DebouncedSearchProviderElement(super.provider);

  @override
  String get query => (origin as DebouncedSearchProvider).query;
}

String _$searchQueryHash() => r'286abcff51dc844febe02639bb2e883ccab22cfd';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
