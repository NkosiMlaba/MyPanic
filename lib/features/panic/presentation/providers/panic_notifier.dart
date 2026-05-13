/// Riverpod providers for the panic feature.
library;

///
/// Exposes the trigger service, panic notifier, and related dependencies.

import 'dart:async';
import 'dart:io' show Platform;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/core/services/haptic_service.dart';
import 'package:my_panic/core/services/location_service.dart';
import 'package:my_panic/features/panic/data/panic_repository.dart';
import 'package:my_panic/features/panic/domain/panic_state.dart';
import 'package:my_panic/features/user_profile/presentation/providers/settings_provider.dart';

import 'package:my_panic/features/trigger_engine/abstract_trigger_source.dart';
import 'package:my_panic/features/trigger_engine/manual_trigger_source.dart';
import 'package:my_panic/features/trigger_engine/composite_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/native_trigger_bridge.dart';
import 'package:my_panic/features/trigger_engine/notification_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/shake_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/qs_tile_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/widget_trigger_service.dart';
import 'package:my_panic/features/trigger_engine/trigger_settings_provider.dart';
import 'package:my_panic/features/keychain/data/ble_panic_trigger_service.dart';

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

/// Provides the NativeTriggerBridge singleton.
@riverpod
NativeTriggerBridge nativeTriggerBridge(Ref ref) {
  final bridge = NativeTriggerBridge();
  bridge.initialize();
  ref.onDispose(() => bridge.dispose());
  return bridge;
}

/// Provides the active PanicTriggerService.
///
/// Builds a [CompositeTriggerService] that merges the manual trigger with
/// any enabled native triggers (notification, shake, QS tile).
@riverpod
PanicTriggerService activeTriggerService(Ref ref) {
  final manual = ref.watch(manualTriggerServiceProvider);
  final settings = ref.watch(triggerSettingsProvider);
  final bridge = ref.watch(nativeTriggerBridgeProvider);

  final sources = <PanicTriggerService>[manual];

  if (settings.notificationTriggerEnabled) {
    sources.add(NotificationTriggerService(bridge));
  }
  if (settings.shakeTriggerEnabled) {
    sources.add(ShakeTriggerService(bridge, sensitivity: settings.shakeSensitivity));
  }
  if (settings.qsTileTriggerEnabled && Platform.isAndroid) {
    sources.add(QSTileTriggerService(bridge));
  }

  // Always include widget trigger on Android — widgets are always available
  if (Platform.isAndroid) {
    sources.add(WidgetTriggerService(bridge));
  }

  // BLE keychain trigger. Always included — the service handles
  // "no paired devices yet" internally (its 30s poll will pick up new
  // pairings, and a no-paired-devices state is just no-op).
  sources.add(ref.watch(blePanicTriggerServiceProvider));

  final composite = CompositeTriggerService(sources);
  composite.armSystem(); // Arm all sources so native services start
  ref.onDispose(() => composite.dispose());
  return composite;
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

/// Provides the PanicRepository, wired to the typed MyPanic API client.
@riverpod
PanicRepository panicRepository(Ref ref) {
  return PanicRepository(ref.watch(myPanicApiClientProvider));
}

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
  Future<void> _onPanicTriggered(TriggerEvent event) async {
    if (state is! PanicStateArmed) return;

    await _startCountdown();
  }

  /// Manually trigger panic (for testing or direct button trigger)
  Future<void> triggerPanic() async {
    if (state is! PanicStateArmed) return;

    // Get the manual trigger and fire it
    final manualTrigger = ref.read(manualTriggerServiceProvider);
    manualTrigger.triggerPanic();
  }

  /// Starts the countdown timer.
  Future<void> _startCountdown() async {
    // Check location first
    final locationService = ref.read(locationServiceProvider);
    final serviceEnabled = await locationService.isServiceEnabled();
    final hasPermission = await locationService.hasPermission();

    if (!serviceEnabled || !hasPermission) {
      state = const PanicState.error(
        message: 'Location services or permissions are disabled.',
      );
      return;
    }

    final hapticService = ref.read(hapticServiceProvider);
    hapticService.startPanicVibration();

    // Get duration from settings
    final duration = ref.read(settingsProvider);

    state = PanicState.countingDown(
      secondsRemaining: duration,
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

    final activatedAt = DateTime.now();
    state = PanicState.active(activatedAt: activatedAt);

    try {
      final position = await locationService.getCurrentLocation();

      // Backend owns SMS fan-out via SMSFlow + FanOutAlertJob; the client only
      // POSTs the alert. Recipients are resolved server-side from the user's
      // consented contacts.
      final alertStatus = await panicRepository.sendEmergencyAlert(
        location: position,
        triggeredAt: activatedAt,
      );

      state = PanicState.active(
        activatedAt: activatedAt,
        alertId: alertStatus.alertId,
      );
    } catch (e) {
      state = PanicState.error(
        message: 'Failed to send alert: ${e.toString()}',
        exception: e,
      );
    }
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
