// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_details_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mealDetailsHash() => r'9d7d6dca39525338a04cea2858add0a265e74daa';

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

/// See also [mealDetails].
@ProviderFor(mealDetails)
const mealDetailsProvider = MealDetailsFamily();

/// See also [mealDetails].
class MealDetailsFamily extends Family<AsyncValue<Meal?>> {
  /// See also [mealDetails].
  const MealDetailsFamily();

  /// See also [mealDetails].
  MealDetailsProvider call(
    String id,
  ) {
    return MealDetailsProvider(
      id,
    );
  }

  @override
  MealDetailsProvider getProviderOverride(
    covariant MealDetailsProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'mealDetailsProvider';
}

/// See also [mealDetails].
class MealDetailsProvider extends AutoDisposeFutureProvider<Meal?> {
  /// See also [mealDetails].
  MealDetailsProvider(
    String id,
  ) : this._internal(
          (ref) => mealDetails(
            ref as MealDetailsRef,
            id,
          ),
          from: mealDetailsProvider,
          name: r'mealDetailsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mealDetailsHash,
          dependencies: MealDetailsFamily._dependencies,
          allTransitiveDependencies:
              MealDetailsFamily._allTransitiveDependencies,
          id: id,
        );

  MealDetailsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<Meal?> Function(MealDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MealDetailsProvider._internal(
        (ref) => create(ref as MealDetailsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Meal?> createElement() {
    return _MealDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MealDetailsProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MealDetailsRef on AutoDisposeFutureProviderRef<Meal?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _MealDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Meal?> with MealDetailsRef {
  _MealDetailsProviderElement(super.provider);

  @override
  String get id => (origin as MealDetailsProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
