import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/session/user_session.dart';
import '../../features/address/domain/models/address_model.dart';

/// Handles device location permission, current position, and reverse geocoding.
class LocationService {
  /// Requests location permission.
  /// Returns [true] if the user has granted at-least while-in-use permission.
  Future<bool> requestPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return false;

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  /// Gets a device position, reverse-geocodes it, and returns an [AddressModel]
  /// ready to be saved. Returns [null] if position or geocoding cannot be
  /// resolved — the user will then add their address manually.
  Future<AddressModel?> getCurrentAddress() async {
    try {
      final position = await _getPosition();
      if (position == null) return null;

      final placemark = await _geocodeWithRetry(position);
      if (placemark == null) return null;

      // Build address line from available placemark parts.
      final lineParts = <String>[
        if (placemark.name?.isNotEmpty == true) placemark.name!,
        if (placemark.thoroughfare?.isNotEmpty == true) placemark.thoroughfare!,
        if (placemark.subLocality?.isNotEmpty == true) placemark.subLocality!,
      ];
      // Deduplicate adjacent values geocoding sometimes returns.
      final unique = <String>[];
      for (final part in lineParts) {
        if (unique.isEmpty || unique.last != part) unique.add(part);
      }
      final addressLine =
          unique.isNotEmpty ? unique.join(', ') : (placemark.street ?? '');

      final city = placemark.locality?.isNotEmpty == true
          ? placemark.locality!
          : (placemark.subAdministrativeArea ?? '');

      final state = placemark.administrativeArea ?? '';
      final pincode = placemark.postalCode ?? '';

      // Require at least a city to consider the geocode useful.
      if (addressLine.isEmpty && city.isEmpty) return null;

      final phone = UserSession.instance.phoneNumber ?? '';

      return AddressModel(
        id: '',
        phone: phone,
        address: addressLine.isNotEmpty ? addressLine : city,
        city: city,
        pincode: pincode,
        state: state,
        isActive: true,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Returns a position using the fastest available strategy:
  ///  1. Last known position (instant — no GPS warm-up needed).
  ///  2. Fresh fix with low accuracy if no cached position exists.
  Future<Position?> _getPosition() async {
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) return last;
    } catch (_) {}

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 20),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Attempts reverse geocoding up to 3 times with a 2-second pause between
  /// retries. Returns the first [Placemark] or null if all attempts fail.
  Future<Placemark?> _geocodeWithRetry(Position position) async {
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        ).timeout(const Duration(seconds: 10));

        if (placemarks.isNotEmpty) return placemarks.first;
      } catch (_) {
        if (attempt < 2) {
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }
    return null;
  }
}
