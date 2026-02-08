/// Core failure classes for error handling.
///
/// Based on Clean Architecture principles, application errors
/// should be represented as domain-level Failure classes.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Base sealed class for all application failures
@freezed
sealed class Failure with _$Failure {
  /// Permission was denied by user
  const factory Failure.permission({
    required String message,
    String? permissionType,
  }) = PermissionFailure;

  /// Location service failed
  const factory Failure.location({
    required String message,
    String? errorCode,
  }) = LocationFailure;

  /// SMS sending failed
  const factory Failure.sms({
    required String message,
    List<String>? failedNumbers,
  }) = SmsFailure;

  /// Network/API failure
  const factory Failure.network({
    required String message,
    int? statusCode,
  }) = NetworkFailure;

  /// Generic unexpected failure
  const factory Failure.unexpected({
    required String message,
    Object? exception,
  }) = UnexpectedFailure;
}
