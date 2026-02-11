/// Panic state definitions using Freezed.
library;

///
/// Represents the different states of the panic system.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'panic_state.freezed.dart';

/// The current state of the panic system.
@freezed
sealed class PanicState with _$PanicState {
  /// System is idle, ready for activation
  const factory PanicState.idle() = PanicStateIdle;

  /// System is armed and waiting for trigger
  const factory PanicState.armed() = PanicStateArmed;

  /// Countdown is active, user can still cancel
  const factory PanicState.countingDown({
    required int secondsRemaining,
    required DateTime triggeredAt,
  }) = PanicStateCountingDown;

  /// Alert is being sent / has been sent
  const factory PanicState.active({
    required DateTime activatedAt,
    String? alertId,
  }) = PanicStateActive;

  /// User cancelled during countdown
  const factory PanicState.cancelled({required DateTime cancelledAt}) =
      PanicStateCancelled;

  /// Error occurred during panic process
  const factory PanicState.error({required String message, Object? exception}) =
      PanicStateError;
}
