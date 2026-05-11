# MyPanic Flutter — Firebase → Supabase Migration: Resume Document

**Last session:** 2026-05-11. Migration Tasks 1–6 complete (incl. 4b/4c/4d). Riverpod 2 → 4 + Freezed 2 → 3 upgrade done as forced collateral (Dart SDK 3.11 needed analyzer 7.x).

## Where to start next session

The authoritative plan with all eng-review fixes lives at:

```
C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\docs\superpowers\plans\2026-05-09-flutter-supabase-migration.md
```

Read these sections first, in this order:

1. **Header** (lines 1–17) — Goal, Architecture, Tech Stack, Hard prerequisites
2. **Eng-Review Addendum** (lines 19–131) — 17 fixes, the renumbered task list, coverage diagram. **The addendum overrides the original task text wherever they conflict.**
3. **Original tasks** (after "## Task 1", line 179) — for syntactic detail. Always cross-check against the addendum.

## The backend is already deployed

`MyPanic.Api` shipped at `v0.1.0-foundation` (image `ghcr.io/antoinekizuri/mypanic-api:0.1.0-foundation`). All 13 endpoints from the foundation plan work. For Tasks 5–8 to be smoke-testable end-to-end:
- **Android emulator:** `MYPANIC_API_BASE_URL=http://10.0.2.2:5187`
- **Real Android device on same WiFi:** dev machine's LAN IP (`http://192.168.1.X:5187`)

## Repo state at checkpoint (2026-05-11 session 2 end)

- Flutter SDK: `3.41.9` at `C:\src\flutter\bin\flutter.bat` (NOT on PATH — invoke via full path)
- **Riverpod upgraded 2.6.1 → 4.0.2** (forced by Dart 3.11 needing analyzer 7.x; legacy `StateNotifier`/`StateNotifierProvider` available via `package:flutter_riverpod/legacy.dart`)
- **Freezed upgraded 2.5.8 → 3.2.5** (requires `abstract class Foo with _$Foo {...}` pattern; `maybeWhen`/`maybeMap` removed unless opted-in)
- `flutter analyze` on auth scope (`lib/features/auth lib/core/auth lib/core/router lib/main.dart`): **0 errors**, 9 info-level (pre-existing `print` calls in router + 1 unnecessary import)
- `flutter analyze` project-wide: ~67 issues, **all concentrated in files Tasks 5–8 will rewrite** (sync_service.dart, contacts_repository.dart, user_profile_repository.dart still on Firestore/firebase_auth)
- 2 untracked files: `lib/core/auth/auth_link_handler.dart`, `lib/features/auth/data/app_user.dart`
- Logs not in git: `pubspec.lock`, `build_runner.log`, `pub_get.log`

## What's done (Tasks 1–4d)

| Task | Status | Notes |
|------|--------|-------|
| 1: Swap pubspec deps + strip Google Services Gradle plugin | ✓ (`d366a0b`) | |
| 2: `ApiOptions` for `--dart-define` config | ✓ (`fff83af`) | |
| 3: `Supabase.initialize` + session-validate-at-boot | ✓ (`b96dbe8`) | PKCE auth flow. Override #5 applied. |
| 4: AppUser + AuthRepository on Supabase + AuthNotifier | ✓ (this session) | `.handleError(...)` on auth streams per override #3. AppUser doc comment per override #8. |
| 4b: Rewrite verify_email_screen.dart | ✓ (this session) | `resendSignupConfirmation` + `refreshSession` instead of Firebase methods. Clears `signupAwaitingConfirmationProvider` once verified. |
| 4c: Signup awaiting-confirmation state | ✓ (this session) | New `signupAwaitingConfirmationProvider` (30s window) at `lib/features/auth/presentation/providers/auth_notifier.dart`. signup_screen calls `.mark()`. Router redirects `!isLoggedIn && awaitingConfirmation` → `/verify-email`. |
| 4d: PKCE deep-link handling | ✓ (this session) | New `lib/core/auth/auth_link_handler.dart`. `app_links: ^6.3.2` in pubspec. AndroidManifest intent-filter for `io.kizuri.mypanic://auth-callback`. `_authLinkHandler` initialized in main.dart. **Pending external step:** in Supabase Studio → Authentication → URL Configuration, add `io.kizuri.mypanic://auth-callback` to Redirect URLs. |
| Riverpod + Freezed upgrade (collateral) | ✓ (this session) | See notes below. |
| 5: MyPanicApiClient + ApiException | ✓ (this session, commit `24fa8ff`) | 401-retry-once (override #4), `/health` misconfig probe (override #16), `Uri.resolveUri` joining (override #17). Provider is `keepAlive` so the http.Client is reused. `lib/core/api/{api_exception.dart,my_panic_api_client.dart}`. Analyzer clean. |
| 6: UserProfileRepository on the API | ✓ (this session, commit `c40cdfe`) | `GET/PUT /api/v1/profiles/me` via `MyPanicApiClient`. Wire-shape adapter: in-app `UserProfile`/`MedicalProfile` (nested + list allergies/conditions) ↔ API flat `ProfileResponse`/`UpdateProfileRequest` (comma-joined string allergies/conditions). UID is read from `authUserId`, falling back to current Supabase session. **Lossy fields (dropped on write, defaulted on read):** `medications`, `emergencyNotes`, `insuranceInfo`, `doctorName`, `doctorPhone`, `countdownDuration` — accepted trade-off, v0.1.0-foundation API doesn't expose them. `watchUserProfile()` is a `_PausablePollStream` (30s) that observes `WidgetsBindingObserver` and goes quiet on `paused`/`hidden`/`detached`, with an immediate refresh on foreground (override #17). Analyzer clean on Task 6 + auth + api + main.dart scope. |

## What's next (Tasks 7–10 per addendum renumbering)

Same as previous session's resume doc but with these adjustments learned this session:

- **`Ref` is the universal type now** — no more `XyzRef` typedefs. New providers (`@riverpod SomeThing foo(Ref ref) { ... }`) use bare `Ref` from `package:flutter_riverpod/flutter_riverpod.dart` (or `package:riverpod_annotation/riverpod_annotation.dart` which re-exports it).
- **Class-based notifiers generate `<lowercaseClassName-minus-Notifier>Provider`.** `AuthNotifier` → `authProvider`, `PanicNotifier` → `panicProvider`. Use this naming for any new class-based notifiers in Tasks 5–8.
- **`AsyncValue.valueOrNull` → `.value`** (returns nullable on base class).
- **Freezed classes need `abstract class Foo with _$Foo {...}`** (or `sealed class`).
- **`maybeWhen` / `maybeMap` are off by default** in Freezed 3.x. Either opt in per-class via `@Freezed(when: FreezedWhenOptions(maybeWhen: true))`, or use `switch (state) { CaseA() => ..., _ => ... }` patterns instead.
- **Riverpod 4's `ProviderObserver` API** uses `ProviderObserverContext context` as the first arg (already updated in `riverpod_logger.dart`).

| New # | Brief |
|-------|-------|
| 7 | `ContactsRepository` + `SyncService` REST-backed. Override #13 race fixes: `_syncLock` Completer; flush-then-sync ordering on connectivity restore; merge-not-replace when `hasPendingChanges()`. **Note:** the API contact DTO shape will likely need the same kind of adapter layer Task 6 introduced — check `EmergencyContact` (Flutter) vs `ContactResponse`/`UpsertContactRequest` (API) for field-name and type drift before mapping. |
| 8 (NEW, P0) | **PanicRepository → MyPanicApiClient.** `sendEmergencyAlert` becomes `await _api.post('/api/v1/alerts', {...})`. Generate `clientIdempotencyKey = const Uuid().v4()`. Drop `sendSmsToContacts`. Update `panic_notifier.dart`. |
| 9 (NEW) | **xUnit-equivalent Flutter test project.** Add `mocktail` to dev_dependencies. Cover all 15 paths from the coverage diagram. **CRITICAL** test: `MyPanicApiClient` 401-retry. |
| 10 | End-to-end smoke test on real Huawei device. |

## Discipline used this session

Per task: implementer → spec compliance check → code quality review → fix loop. Done inline (controller-side) for Tasks 4 and 4b–d because changes were small and well-anchored.

## How to resume

```
Read C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\RESUME-MIGRATION.md and continue.
```

Flutter binary: `C:\src\flutter\bin\flutter.bat` (not on PATH). Working dir: `C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\`.

PowerShell preferred over Bash for invoking `flutter.bat` / `dart.bat` — the Bash wrapper appears to swallow stdout/stderr on long-running processes in this environment.

## Forward-looking notes

- `_prefs!.setInt` in `settings_provider.dart` triggers a non-null warning (`_prefs` was hinted non-null somehow by inference). Cosmetic, leave for now.
- Task 6 dropped the local-only `MedicalProfile` fields (`medications`, `emergencyNotes`, `insuranceInfo`, `doctorName`, `doctorPhone`) and `UserProfile.countdownDuration` from the wire format. The UI screens (`onboarding_screen.dart`, `edit_profile_screen.dart`) still render those TextFields — typed values won't persist. If we want to clean that up before shipping, either remove the fields from the UI or extend the API DTOs. Not blocking Task 7+.
- Other deferred work from previous session still applies: CI workflow update (override #6) and Task 8a Firestore-rules-deny step (dropped — no real users).
