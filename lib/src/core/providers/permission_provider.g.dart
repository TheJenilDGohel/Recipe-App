// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$locationPermissionStatusHash() =>
    r'3727b75aba248f6b9e0d23b7c5338aee28f059a6';

/// See also [LocationPermissionStatus].
@ProviderFor(LocationPermissionStatus)
final locationPermissionStatusProvider = AutoDisposeAsyncNotifierProvider<
    LocationPermissionStatus, LocationPermission>.internal(
  LocationPermissionStatus.new,
  name: r'locationPermissionStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locationPermissionStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocationPermissionStatus
    = AutoDisposeAsyncNotifier<LocationPermission>;
String _$notificationPermissionStatusHash() =>
    r'eb03e876aa394bc3072a68bf911a8f9b1b1872fa';

/// See also [NotificationPermissionStatus].
@ProviderFor(NotificationPermissionStatus)
final notificationPermissionStatusProvider = AutoDisposeAsyncNotifierProvider<
    NotificationPermissionStatus, bool>.internal(
  NotificationPermissionStatus.new,
  name: r'notificationPermissionStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPermissionStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationPermissionStatus = AutoDisposeAsyncNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
