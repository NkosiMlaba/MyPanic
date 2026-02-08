/// Riverpod providers for the panic feature.
///
/// Exposes the trigger service, panic notifier, and related dependencies.

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/core/services/haptic_service.dart';
import 'package:my_panic/core/services/location_service.dart';
import 'package:my_panic/features/panic/data/panic_repository.dart';
import 'package:my_panic/features/panic/domain/panic_state.dart';
import 'package:my_panic/features/panic/domain/entities/emergency_contact.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/trigger_engine/abstract_trigger_source.dart';
import 'package:my_panic/features/trigger_engine/manual_trigger_source.dart';

part 'panic_notifier.g.dart';

/// Provides the ManualPanicTriggerService instance.
/// This can be swapped for BlePanicTriggerService in Phase 2.
@riverpod
ManualPanicTriggerService manualTriggerService(Ref ref) {
  final service = ManualPanicTriggerService();
  service.armSystem(); // Arm by default for MVP

  ref.onDispose(() {
    service.dispose();
  });

  return service;
}

/// Provides the active PanicTriggerService.
/// This abstraction allows swapping trigger implementations.
@riverpod
PanicTriggerService activeTriggerService(Ref ref) {
  // For MVP, always use manual trigger
  // In Phase 2, this could check user settings to use BLE
  return ref.watch(manualTriggerServiceProvider);
}

/// Provides the HapticService.
@riverpod
HapticService hapticService(Ref ref) {
  return HapticService();
}

/// Provides the LocationService.
@riverpod
LocationService locationService(Ref ref) {
  return LocationService();
}

/// Provides the PanicRepository.
@riverpod
PanicRepository panicRepository(Ref ref) {
  return PanicRepository();
}

/// Countdown duration in seconds
const int countdownDuration = 30;

/// Main panic state notifier.
/// Listens to trigger events and manages the panic flow.
@riverpod
class PanicNotifier extends _$PanicNotifier {
  Timer? _countdownTimer;
  StreamSubscription<TriggerEvent>? _triggerSubscription;

  @override
  PanicState build() {
    // Listen to trigger events
    final triggerService = ref.watch(activeTriggerServiceProvider);

    _triggerSubscription = triggerService.onPanicTriggered.listen((event) {
      _onPanicTriggered(event);
    });

    ref.onDispose(() {
      _countdownTimer?.cancel();
      _triggerSubscription?.cancel();
    });

    return const PanicState.armed();
  }

  /// Called when a panic trigger event is received.
  void _onPanicTriggered(TriggerEvent event) {
    if (state is! PanicStateArmed) return;

    _startCountdown();
  }

  /// Manually trigger panic (for testing or direct button trigger)
  void triggerPanic() {
    if (state is! PanicStateArmed) return;

    // Get the manual trigger and fire it
    final manualTrigger = ref.read(manualTriggerServiceProvider);
    manualTrigger.triggerPanic();
  }

  /// Starts the countdown timer.
  void _startCountdown() {
    final hapticService = ref.read(hapticServiceProvider);
    hapticService.startPanicVibration();

    state = PanicState.countingDown(
      secondsRemaining: countdownDuration,
      triggeredAt: DateTime.now(),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is PanicStateCountingDown) {
        final newSeconds = currentState.secondsRemaining - 1;

        if (newSeconds <= 0) {
          timer.cancel();
          _activateAlert();
        } else {
          state = currentState.copyWith(secondsRemaining: newSeconds);
        }
      } else {
        timer.cancel();
      }
    });
  }

  /// Cancels the panic countdown.
  void cancelPanic() {
    _countdownTimer?.cancel();
    _countdownTimer = null;

    final hapticService = ref.read(hapticServiceProvider);
    hapticService.stopVibration();

    state = PanicState.cancelled(cancelledAt: DateTime.now());

    // Reset to armed state after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (state is PanicStateCancelled) {
        state = const PanicState.armed();
      }
    });
  }

  /// Activates the emergency alert.
  Future<void> _activateAlert() async {
    final hapticService = ref.read(hapticServiceProvider);
    final locationService = ref.read(locationServiceProvider);
    final panicRepository = ref.read(panicRepositoryProvider);

    hapticService.stopVibration();
    hapticService.emergencyAlertFeedback();

    state = PanicState.active(activatedAt: DateTime.now());

    try {
      // Get current location
      final position = await locationService.getCurrentLocation();

      // Get emergency contacts (dummy for MVP)
      final contacts = _getDummyContacts();

      // Get medical profile (empty for MVP)
      const profile = MedicalProfile();

      // Send SMS to contacts
      await panicRepository.sendSmsToContacts(
        contacts: contacts,
        location: position,
      );

      // Send to backend
      final alertStatus = await panicRepository.sendEmergencyAlert(
        location: position,
        profile: profile,
        contacts: contacts,
      );

      state = PanicState.active(
        activatedAt: DateTime.now(),
        alertId: alertStatus.alertId,
      );
    } catch (e) {
      state = PanicState.error(
        message: 'Failed to send alert: ${e.toString()}',
        exception: e,
      );
    }
  }

  /// Returns dummy contacts for MVP testing.
  List<EmergencyContact> _getDummyContacts() {
    return [
      const EmergencyContact(
        id: '1',
        name: 'Mom',
        phone: '+27123456789',
        relationship: 'Parent',
      ),
      const EmergencyContact(
        id: '2',
        name: 'Dad',
        phone: '+27123456780',
        relationship: 'Parent',
      ),
      const EmergencyContact(
        id: '3',
        name: 'Campus Security',
        phone: '+27123456781',
        relationship: 'Emergency Service',
      ),
      const EmergencyContact(
        id: '4',
        name: 'Best Friend',
        phone: '+27123456782',
        relationship: 'Friend',
      ),
      const EmergencyContact(
        id: '5',
        name: 'Resident Advisor',
        phone: '+27123456783',
        relationship: 'University Staff',
      ),
    ];
  }

  /// Resets the panic system to armed state.
  void reset() {
    _countdownTimer?.cancel();
    _countdownTimer = null;

    final hapticService = ref.read(hapticServiceProvider);
    hapticService.stopVibration();

    state = const PanicState.armed();
  }
}
