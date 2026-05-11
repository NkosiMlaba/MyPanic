import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:my_panic/core/api/api_exception.dart';
import 'package:my_panic/core/api/my_panic_api_client.dart';
import 'package:my_panic/features/panic/domain/entities/medical_profile.dart';
import 'package:my_panic/features/user_profile/domain/entities/user_profile.dart';

part 'user_profile_repository.g.dart';

@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  return UserProfileRepository(
    ref.watch(myPanicApiClientProvider),
    Supabase.instance.client,
  );
}

/// REST-backed replacement for the old Firestore-backed profile repo.
///
/// The on-the-wire shape (`ProfileResponse` / `UpdateProfileRequest`) is
/// flatter than the in-app `UserProfile`: allergies/conditions are
/// comma-joined strings on the server side, and medications / emergency notes
/// / insurance / doctor fields / countdownDuration are not yet on the API.
/// Those local-only fields are preserved through Freezed defaults on read and
/// dropped on write — that's the deliberate trade-off captured in the Task 6
/// brief.
class UserProfileRepository {
  final MyPanicApiClient _api;
  final SupabaseClient _supabase;

  /// Profile data changes rarely; a 30s poll covers the home-screen widgets.
  static const _pollInterval = Duration(seconds: 30);

  UserProfileRepository(this._api, this._supabase);

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<void> createUserProfile(UserProfile profile) async {
    await _api.put('/api/v1/profiles/me', _toUpdateRequest(profile));
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await _api.put('/api/v1/profiles/me', _toUpdateRequest(profile));
  }

  Future<UserProfile?> getUserProfile() async {
    if (currentUserId == null) return null;
    try {
      final json =
          await _api.get('/api/v1/profiles/me') as Map<String, dynamic>;
      return _fromProfileResponse(json);
    } on ApiException catch (e) {
      if (e.isNotFound) return null;
      rethrow;
    }
  }

  /// Replacement for the old Firestore `snapshots()` stream. Per override #17,
  /// polling pauses while the app is backgrounded (no point burning the
  /// network on data the user can't see) and resumes on foreground with an
  /// immediate refresh.
  Stream<UserProfile?> watchUserProfile() {
    if (currentUserId == null) return Stream.value(null);
    return _PausablePollStream(_pollInterval, getUserProfile).stream;
  }

  // ── Wire-format adapters ────────────────────────────────────────────────

  Map<String, dynamic> _toUpdateRequest(UserProfile profile) {
    final med = profile.medicalProfile;
    return {
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'phone': profile.phoneNumber,
      'bloodType': med.bloodType,
      'allergies': _joinList(med.allergies),
      'conditions': _joinList(med.conditions),
    };
  }

  UserProfile _fromProfileResponse(Map<String, dynamic> json) {
    return UserProfile(
      uid: (json['authUserId'] as String?) ?? currentUserId ?? '',
      email: (json['email'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      phoneNumber: (json['phone'] as String?) ?? '',
      medicalProfile: MedicalProfile(
        bloodType: json['bloodType'] as String?,
        allergies: _splitList(json['allergies'] as String?),
        conditions: _splitList(json['conditions'] as String?),
      ),
      isProfileComplete: (json['isProfileComplete'] as bool?) ?? false,
    );
  }

  static String? _joinList(List<String> values) {
    final cleaned = values.map((v) => v.trim()).where((v) => v.isNotEmpty);
    if (cleaned.isEmpty) return null;
    return cleaned.join(', ');
  }

  static List<String> _splitList(String? csv) {
    if (csv == null || csv.trim().isEmpty) return const [];
    return csv
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }
}

/// Polls [fetch] every [interval] but goes quiet while the OS reports the app
/// is hidden/paused. Foregrounding triggers an immediate refresh so the UI
/// doesn't show stale data for up to a full poll period.
class _PausablePollStream with WidgetsBindingObserver {
  _PausablePollStream(this._interval, this._fetch) {
    WidgetsBinding.instance.addObserver(this);
    _controller = StreamController<UserProfile?>(
      onListen: _start,
      onCancel: _stop,
    );
  }

  final Duration _interval;
  final Future<UserProfile?> Function() _fetch;
  late final StreamController<UserProfile?> _controller;
  Timer? _timer;
  bool _paused = false;

  Stream<UserProfile?> get stream => _controller.stream;

  Future<void> _start() async {
    await _tick();
    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    if (_paused) return;
    _timer = Timer(_interval, () async {
      await _tick();
      _scheduleNext();
    });
  }

  Future<void> _tick() async {
    if (_controller.isClosed) return;
    try {
      final value = await _fetch();
      if (!_controller.isClosed) _controller.add(value);
    } catch (_) {
      // Don't kill the stream on transient errors; the next tick retries.
    }
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
    _controller.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final shouldPause =
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached;
    if (shouldPause && !_paused) {
      _paused = true;
      _timer?.cancel();
      _timer = null;
    } else if (!shouldPause && _paused) {
      _paused = false;
      // Refresh now so the user sees fresh data on resume rather than
      // waiting up to _interval for the next tick.
      unawaited(_tick().then((_) => _scheduleNext()));
    }
  }
}
