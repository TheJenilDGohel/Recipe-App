import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      // Mitigation: Use timeout on location fetching to prevent hanging
      return await Geolocator.getCurrentPosition()
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCountryFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 10));
      
      if (placemarks.isNotEmpty) {
        // Mitigation: Only extract 'country' field from placemark
        return placemarks.first.country;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

@riverpod
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}
