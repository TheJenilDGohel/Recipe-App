// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contextual_discovery_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentTimeHash() => r'8e2c578a58f761bb4299f62489ac03053fe692d5';

/// See also [currentTime].
@ProviderFor(currentTime)
final currentTimeProvider = AutoDisposeProvider<DateTime>.internal(
  currentTime,
  name: r'currentTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentTimeRef = AutoDisposeProviderRef<DateTime>;
String _$contextualDiscoveryHash() =>
    r'ba06d4bb46bb8132d703b11e021d67d365da4396';

/// See also [contextualDiscovery].
@ProviderFor(contextualDiscovery)
final contextualDiscoveryProvider =
    AutoDisposeFutureProvider<List<Meal>>.internal(
  contextualDiscovery,
  name: r'contextualDiscoveryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contextualDiscoveryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ContextualDiscoveryRef = AutoDisposeFutureProviderRef<List<Meal>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
