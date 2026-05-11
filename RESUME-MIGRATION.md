# MyPanic Flutter — Firebase → Supabase Migration: Resume Document

**Last session:** 2026-05-11. Migration Tasks 1–3 complete. Stopped here for fresh-context execution of Tasks 4–10 (renumbered per the eng-review addendum).

## Where to start next session

The authoritative plan with all eng-review fixes lives at:

```
C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\docs\superpowers\plans\2026-05-09-flutter-supabase-migration.md
```

**Read these sections first, in this order:**

1. **Header** (lines 1–17) — Goal, Architecture, Tech Stack, Hard prerequisites
2. **Eng-Review Addendum** (right after the header, lines 19–100) — 17 fixes, the renumbered task list, coverage diagram. **The addendum overrides the original task text wherever they conflict.** Two P0 bugs caught: PanicRepository was a stub (override #1 → new Task 8), verify_email_screen calls Firebase methods on AppUser (override #2 → new Task 4b).
3. **Original tasks** (after "## Task 1: Swap pubspec dependencies", line 179) — for syntactic detail. Always cross-check against the addendum.

## The backend is already deployed

`MyPanic.Api` shipped at `v0.1.0-foundation` (image `ghcr.io/antoinekizuri/mypanic-api:0.1.0-foundation`). All 13 endpoints from the foundation plan work:
- `POST /api/v1/alerts`, `GET /api/v1/alerts/{id}`, `POST /api/v1/alerts/{id}/cancel`
- `GET /api/v1/profiles/me`, `PUT /api/v1/profiles/me`
- `GET /api/v1/contacts`, `PUT /api/v1/contacts`, `DELETE /api/v1/contacts/{id}`, `POST /api/v1/contacts/{id}/consent`, `POST /api/v1/contacts/{id}/opt-out`
- `POST /api/v1/tenants/assign`
- `GET /health`

The API can run locally via `dotnet run --project src/MyPanic.Api` against the existing Supabase project (`wumvtdivfwuyqdtbizrt.supabase.co`). For Tasks 5–7 of THIS plan to be smoke-testable end-to-end, the API needs to be reachable from the Flutter dev environment:
- **Android emulator:** `MYPANIC_API_BASE_URL=http://10.0.2.2:5187`
- **Real Android device on same WiFi:** dev machine's LAN IP (`http://192.168.1.X:5187`)
- **Deployed:** Fly.io / Render / etc. — pull `ghcr.io/antoinekizuri/mypanic-api:latest`

## Repo state at checkpoint

- 3 new commits on Flutter `main` (untracked → on local `main`, no remote yet)
- Flutter SDK: `3.41.9` at `C:\src\flutter\bin\flutter.bat` (not on PATH — use full path)
- `flutter analyze`: **39 errors, 0 warnings, 34 infos** — all in Firebase-using files that Tasks 4–7 will fix
- Errors are confined to: `auth_repository.dart`, `auth_notifier.dart`, `contacts_repository.dart`, `user_profile_repository.dart`, `sync_service.dart`, `verify_email_screen.dart`
- `pubspec.lock` is gitignored in this project — Task 8 verification should NOT depend on tracked lock file
- No `firebase_options.dart` ever existed (init used bare `Firebase.initializeApp()` reading `google-services.json`); no leftover file to delete in Task 8

## What's done (Tasks 1–3)

| Task | Status | Commit | Notes |
|------|--------|--------|-------|
| 1: Swap pubspec deps (Firebase out, supabase_flutter + http in) + strip Google Services Gradle plugin | ✓ | `d366a0b` | `supabase_flutter ^2.12.4`, `http ^1.6.0`. Two Gradle files edited. |
| 2: `ApiOptions` for `--dart-define` config | ✓ | `fff83af` | `lib/core/api/api_options.dart`. Three constants, `assertConfigured()` throws when any are empty. |
| 3: `Supabase.initialize` in `main.dart` + session-validate-at-boot (override #5) | ✓ | `b96dbe8` | Firebase imports removed. PKCE auth flow. If persisted session is expired, refresh; on refresh fail, sign out cleanly. |

## What's next (Tasks 4–10 per addendum renumbering)

| New # | Original / NEW | Brief |
|-------|--------------|-------|
| 4 | original 4 | AppUser value type + AuthRepository on Supabase. Public method signatures stay stable (signIn, signUp, signOut, authStateChanges, currentUser). Internals swap Firebase → Supabase. AppUser doc comment per override #8 explicitly states "Matches Profile.auth_user_id on the server, NOT Profile.id". Add `.handleError(...)` to authStateChanges/userChanges per override #3. |
| 4b (NEW) | override #2 | **Rewrite `verify_email_screen.dart` for Supabase.** Replace `user.sendEmailVerification()` → `_client.auth.resend(type: OtpType.signup, email: user.email)`. Replace `user.reload()`+`user.emailVerified` polling → `await _client.auth.refreshSession()` then read `currentUser?.emailVerified` (AppUser getter maps from `emailConfirmedAt`). |
| 4c (NEW) | override #15 | **Signup awaiting-confirmation state.** Supabase `signUp()` returns null session when email confirmation is enabled. AuthNotifier exposes `isAwaitingEmailConfirmation` (30s window after submit). Router redirect: if true and on `/signup`, route to `/verify-email`. Alternative: disable email confirmation in Supabase Studio. |
| 4d (NEW) | override #14 / section C | **PKCE deep-link handling.** Add `app_links: ^6.x` to pubspec. AndroidManifest intent-filter for scheme `io.kizuri.mypanic` host `auth-callback`. Supabase Studio → Authentication → URL Configuration → add `io.kizuri.mypanic://auth-callback` to Redirect URLs. New file `lib/core/auth/auth_link_handler.dart` subscribed in main.dart. Without this, password-reset and email-confirmation links open in browser and never return to app. |
| 5 | original 5 | `MyPanicApiClient` + `ApiException`. Wraps `package:http` with Bearer-token attachment from `Supabase.instance.client.auth.currentSession?.accessToken`. 401-retry-once after `refreshSession()` per override #4. Misconfig-surfacing `GET /health` HEAD at first instantiation per override #16. URI handling via `Uri.parse(...).resolveUri(...)` per override #17. |
| 6 | original 6 | `UserProfileRepository` on the API. `GET /profiles/me`, `PUT /profiles/me`. Returns null on 404. `watchUserProfile` polls + pauses on app-backgrounded via `WidgetsBindingObserver` per override #17. |
| 7 | original 7 | `ContactsRepository` + `SyncService` REST-backed offline-first. **Critical fixes per override #13:** `_syncLock` Completer; flush-then-sync ordering on connectivity restore; before `replaceContacts(serverList)`, check `hasPendingChanges()` and MERGE instead of replace. ~30 lines of new code. |
| 8 (NEW) | override #1 (P0) | **PanicRepository → MyPanicApiClient.** `sendEmergencyAlert` becomes `await _api.post('/api/v1/alerts', {...})`. Generate `clientIdempotencyKey = const Uuid().v4()`. Drop `sendSmsToContacts` entirely (backend owns SMS). Drop `cancelAlert`'s simulated logic; replace with `await _api.post('/api/v1/alerts/$alertId/cancel', null)`. Update `panic_notifier.dart`. **Without this, the panic button doesn't actually call the backend.** |
| ~~8a~~ | ~~override #7~~ | **DROPPED** — confirmed 2026-05-11: no real users on the existing Firebase backend, only dev/testers. No data to preserve, no migration window needed. When the new Flutter app is ready, just ship it. |
| 9 (NEW) | override #10 | **xUnit-equivalent Flutter test project.** Add `mocktail` to dev_dependencies. Cover all 15 paths from the addendum's coverage diagram. **CRITICAL** test: `MyPanicApiClient` 401-retry. Without this, future refactors break the silent retry. |
| 10 | original 9 (smoke test) | End-to-end smoke test on real Huawei device (or Android emulator). Now actually exercises the backend per override #1's PanicRepository fix. Stopwatch from button-press → MyPanic.Api logs receiving POST /alerts. |

## Discipline used in this session

Per task: **implementer subagent → spec compliance check → code quality review → fix loop until both reviewers approve → mark complete**.

For Tasks 1–3 the spec compliance check was inline (controller-side) because the changes were small and well-anchored to the plan body. Tasks 4+ are bigger and benefit from full subagent reviews.

## How to resume

In a fresh Claude Code session in this repo:

```
Read C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\RESUME-MIGRATION.md and continue.
```

The Flutter binary is at `C:\src\flutter\bin\flutter.bat` (NOT on PATH — invoke via full path). Working directory for all commands: `C:\Users\User\Documents\Kizuri\Business\Project Management\MyPanic-ui\MyPanic\`.

## Forward-looking notes

- The Flutter `main.dart` will need `firebase_options.dart` cleanup if it gets generated by Flutter tooling later — we kept it out of scope for Tasks 1–3.
- The `cloud_firestore` import in `sync_service.dart` (currently broken) gets removed in Task 7 along with the entire Firestore-backed sync rewrite.
- The AppUser type from override #8 needs the `auth_user_id`-vs-`Profile.id` semantic in its doc comment — Flutter only ever sends the auth UUID, the backend resolves "me" from the JWT.
- The CI workflow update (override #6, dart-defines via GitHub secrets) is captured in Task 1 of the plan but explicitly deferred to a later session — Task 21+ depending on how we renumber.
