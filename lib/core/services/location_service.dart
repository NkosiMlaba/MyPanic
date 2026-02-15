/// Location service for getting user's position.
library;

///
/// Uses geolocator package for GPS location.

import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:my_panic/core/errors/exceptions.dart';

/// Service for handling location-related operations.
class LocationService {
  /// Gets the current position of the device.
  ///
  /// Throws [LocationException] if location services are disabled
  /// or permissions are denied.
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException.serviceDisabled();
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException.permissionDenied();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationException(
        'Location permissions are permanently denied',
        code: 'PERMISSION_DENIED_FOREVER',
      );
    }

    // Get position with high accuracy for emergency situations
    // Get position with high accuracy for emergency situations
    // Get position with high accuracy for emergency situations
    // ignore: deprecated_member_use
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Checks if location permission is granted.
  Future<bool> hasPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Requests location permission.
  Future<bool> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Checks if location services are enabled.
  Future<bool> isServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}
