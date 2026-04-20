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

  /// Gets the current device position and reverse-geocodes it into an
  /// [AddressModel] ready to be saved. Returns [null] on any failure.
  Future<AddressModel?> getCurrentAddress() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 15),
        ),
      );

      String addressLine1 = 'Current Location';
      String city = 'Unknown';
      String pincode = '';

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;

          // Build a meaningful first line: name / street / subLocality
          final lineParts = <String>[
            if (p.name != null && p.name!.isNotEmpty) p.name!,
            if (p.thoroughfare != null && p.thoroughfare!.isNotEmpty)
              p.thoroughfare!,
            if (p.subLocality != null && p.subLocality!.isNotEmpty)
              p.subLocality!,
          ];
          // Deduplicate adjacent duplicates that geocoding sometimes returns
          final unique = <String>[];
          for (final part in lineParts) {
            if (unique.isEmpty || unique.last != part) unique.add(part);
          }
          if (unique.isNotEmpty) addressLine1 = unique.join(', ');

          city = p.locality?.isNotEmpty == true
              ? p.locality!
              : (p.administrativeArea ?? 'Unknown');
          pincode = p.postalCode ?? '';
        }
      } catch (_) {
        // Geocoding failed — fall back to raw coordinates.
        addressLine1 =
            '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
      }

      final userId = UserSession.instance.userId ?? '';
      final phone = UserSession.instance.phoneNumber ?? '';

      return AddressModel(
        id: '',
        userId: userId,
        phone: phone,
        label: 'Home',
        address: addressLine1,
        city: city,
        pincode: pincode,
        isActive: true,
      );
    } catch (_) {
      return null;
    }
  }
}
