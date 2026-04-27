import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

part 'permission_provider.g.dart';

@riverpod
class LocationPermissionStatus extends _$LocationPermissionStatus {
  @override
  Future<LocationPermission> build() async {
    return await Geolocator.checkPermission();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => Geolocator.checkPermission());
  }

  Future<void> request() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => Geolocator.requestPermission());
  }
}

@riverpod
class NotificationPermissionStatus extends _$NotificationPermissionStatus {
  @override
  Future<bool> build() async {
    if (Platform.isIOS) {
      // Basic check for iOS
      return true; // Simplified for this example
    } else if (Platform.isAndroid) {
      final plugin = FlutterLocalNotificationsPlugin();
      final androidImplementation = plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        final granted = await androidImplementation.areNotificationsEnabled();
        return granted ?? false;
      }
    }
    return false;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (Platform.isAndroid) {
        final plugin = FlutterLocalNotificationsPlugin();
        final androidImplementation = plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        if (androidImplementation != null) {
          final granted = await androidImplementation.areNotificationsEnabled();
          return granted ?? false;
        }
      }
      return true;
    });
  }
}
