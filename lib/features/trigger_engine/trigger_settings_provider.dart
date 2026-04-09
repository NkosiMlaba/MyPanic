/// Provider for trigger method settings.
library;

///
/// Persists which trigger sources are enabled and their configuration
/// (e.g. shake sensitivity) using SharedPreferences.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'package:my_panic/features/trigger_engine/shake_trigger_service.dart';
import 'package:my_panic/features/user_profile/presentation/providers/settings_provider.dart';

/// Immutable snapshot of trigger settings.
class TriggerSettings {
  final bool notificationTriggerEnabled;
  final bool shakeTriggerEnabled;
  final ShakeSensitivity shakeSensitivity;
  final bool qsTileTriggerEnabled;

  const TriggerSettings({
    this.notificationTriggerEnabled = false,
    this.shakeTriggerEnabled = false,
    this.shakeSensitivity = ShakeSensitivity.medium,
    this.qsTileTriggerEnabled = false,
  });

  TriggerSettings copyWith({
    bool? notificationTriggerEnabled,
    bool? shakeTriggerEnabled,
    ShakeSensitivity? shakeSensitivity,
    bool? qsTileTriggerEnabled,
  }) {
    return TriggerSettings(
      notificationTriggerEnabled:
          notificationTriggerEnabled ?? this.notificationTriggerEnabled,
      shakeTriggerEnabled: shakeTriggerEnabled ?? this.shakeTriggerEnabled,
      shakeSensitivity: shakeSensitivity ?? this.shakeSensitivity,
      qsTileTriggerEnabled:
          qsTileTriggerEnabled ?? this.qsTileTriggerEnabled,
    );
  }
}

/// StateNotifier for trigger settings with SharedPreferences persistence.
class TriggerSettingsNotifier extends StateNotifier<TriggerSettings> {
  final SharedPreferences? _prefs;

  static const _keyNotification = 'trigger_notification_enabled';
  static const _keyShake = 'trigger_shake_enabled';
  static const _keySensitivity = 'trigger_shake_sensitivity';
  static const _keyQSTile = 'trigger_qs_tile_enabled';

  TriggerSettingsNotifier(this._prefs)
      : super(TriggerSettings(
          notificationTriggerEnabled:
              _prefs?.getBool(_keyNotification) ?? (Platform.isAndroid),
          shakeTriggerEnabled: _prefs?.getBool(_keyShake) ?? false,
          shakeSensitivity: _parseSensitivity(
              _prefs?.getString(_keySensitivity)),
          qsTileTriggerEnabled:
              _prefs?.getBool(_keyQSTile) ?? (Platform.isAndroid),
        ));

  static ShakeSensitivity _parseSensitivity(String? value) {
    return switch (value) {
      'low' => ShakeSensitivity.low,
      'high' => ShakeSensitivity.high,
      _ => ShakeSensitivity.medium,
    };
  }

  Future<void> setNotificationTriggerEnabled(bool enabled) async {
    await _prefs?.setBool(_keyNotification, enabled);
    state = state.copyWith(notificationTriggerEnabled: enabled);
  }

  Future<void> setShakeTriggerEnabled(bool enabled) async {
    await _prefs?.setBool(_keyShake, enabled);
    state = state.copyWith(shakeTriggerEnabled: enabled);
  }

  Future<void> setShakeSensitivity(ShakeSensitivity sensitivity) async {
    await _prefs?.setString(_keySensitivity, sensitivity.name);
    state = state.copyWith(shakeSensitivity: sensitivity);
  }

  Future<void> setQSTileTriggerEnabled(bool enabled) async {
    await _prefs?.setBool(_keyQSTile, enabled);
    state = state.copyWith(qsTileTriggerEnabled: enabled);
  }
}

/// Provider for trigger settings.
final triggerSettingsProvider =
    StateNotifierProvider<TriggerSettingsNotifier, TriggerSettings>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return TriggerSettingsNotifier(prefsAsync.valueOrNull);
});
