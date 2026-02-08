/// Haptic feedback service for vibration patterns.
///
/// Provides vibration feedback during panic countdown.

import 'package:vibration/vibration.dart';

/// Service for handling haptic feedback and vibration.
class HapticService {
  bool _isVibrating = false;

  /// Starts a looping vibration pattern for panic countdown.
  ///
  /// Pattern: vibrate 500ms, pause 500ms, repeat
  Future<void> startPanicVibration() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    _isVibrating = true;

    // Looping pattern: [duration, pause, duration, pause, ...]
    // Total pattern length = 30 seconds (countdown duration)
    // 500ms vibrate + 500ms pause = 1 second per cycle
    // 30 cycles for 30 seconds
    final pattern = List<int>.generate(
      60, // 30 vibrations + 30 pauses
      (index) => 500,
    );

    await Vibration.vibrate(pattern: pattern);
  }

  /// Stops the vibration immediately.
  Future<void> stopVibration() async {
    _isVibrating = false;
    await Vibration.cancel();
  }

  /// Quick haptic tap feedback.
  Future<void> tapFeedback() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    await Vibration.vibrate(duration: 50);
  }

  /// Strong haptic feedback for button press.
  Future<void> buttonPressFeedback() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    await Vibration.vibrate(duration: 100);
  }

  /// Emergency alert vibration pattern.
  Future<void> emergencyAlertFeedback() async {
    final hasVibrator = await Vibration.hasVibrator() ?? false;
    if (!hasVibrator) return;

    // SOS pattern in haptic: 3 short, 3 long, 3 short
    await Vibration.vibrate(
      pattern: [0, 100, 100, 100, 100, 100, 200, 300, 100, 300, 100, 300, 200, 100, 100, 100, 100, 100],
    );
  }

  bool get isVibrating => _isVibrating;
}
