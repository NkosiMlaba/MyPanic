/// Permission service for runtime permission requests.
library;

///
/// Centralizes permission handling for notification and sensor permissions
/// required by the trigger engine features.

import 'dart:io' show Platform;
import 'package:permission_handler/permission_handler.dart';

/// Handles runtime permission requests for trigger features.
class PermissionService {
  /// Request notification permission (required on Android 13+ / API 33+).
  ///
  /// Returns true if permission is granted, false otherwise.
  /// On iOS or Android < 13, returns true (no runtime permission needed).
  Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;

    final status = await Permission.notification.status;
    if (status.isGranted) return true;

    final result = await Permission.notification.request();
    return result.isGranted;
  }

  /// Check if notification permission is currently granted.
  Future<bool> hasNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// Check if notification permission is permanently denied.
  Future<bool> isNotificationPermanentlyDenied() async {
    if (!Platform.isAndroid) return false;
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }
}
