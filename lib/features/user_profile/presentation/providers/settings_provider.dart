import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for the SharedPreferences instance
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

/// Notifier for app settings
class SettingsNotifier extends StateNotifier<int> {
  final SharedPreferences? _prefs;

  SettingsNotifier(this._prefs)
    : super(_prefs?.getInt('countdown_duration') ?? 30);

  Future<void> setCountdownDuration(int duration) async {
    if (_prefs == null) return;
    await _prefs!.setInt('countdown_duration', duration);
    state = duration;
  }
}

/// Provider for settings (countdown duration for now)
final settingsProvider = StateNotifierProvider<SettingsNotifier, int>((ref) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefsAsync.valueOrNull);
});
