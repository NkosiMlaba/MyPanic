/// Alert status entity.
library;

///
/// Tracks the status of an emergency alert.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_status.freezed.dart';
part 'alert_status.g.dart';

/// The status of an emergency alert.
@freezed
class AlertStatus with _$AlertStatus {
  const factory AlertStatus({
    required String alertId,
    required DateTime createdAt,
    required AlertState state,
    double? latitude,
    double? longitude,
    @Default([]) List<String> notifiedContacts,
    String? errorMessage,
  }) = _AlertStatus;

  factory AlertStatus.fromJson(Map<String, dynamic> json) =>
      _$AlertStatusFromJson(json);
}

/// Possible states of an alert.
enum AlertState { pending, sending, sent, acknowledged, resolved, failed }
