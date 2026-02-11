/// Custom exception classes for the application.
library;

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Permission related exceptions
class PermissionException extends AppException {
  final String permissionType;

  const PermissionException(super.message, {required this.permissionType})
    : super(code: 'PERMISSION_DENIED');
}

/// Location service exceptions
class LocationException extends AppException {
  const LocationException(super.message, {super.code});

  factory LocationException.serviceDisabled() => const LocationException(
    'Location services are disabled',
    code: 'SERVICE_DISABLED',
  );

  factory LocationException.permissionDenied() => const LocationException(
    'Location permission denied',
    code: 'PERMISSION_DENIED',
  );
}

/// SMS related exceptions
class SmsException extends AppException {
  const SmsException(super.message, {super.code});

  factory SmsException.notSupported() => const SmsException(
    'SMS is not supported on this device',
    code: 'NOT_SUPPORTED',
  );
}

/// Network related exceptions
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(super.message, {this.statusCode, super.code});

  factory NetworkException.noConnection() =>
      const NetworkException('No internet connection', code: 'NO_CONNECTION');

  factory NetworkException.timeout() =>
      const NetworkException('Connection timeout', code: 'TIMEOUT');
}
