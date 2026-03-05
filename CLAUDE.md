# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**MyPanic** — A Flutter personal safety app (Android/iOS) paired with a physical silicone whistle keychain. The app provides a manual panic button with countdown, SMS emergency alerts, live location sharing, and trusted contacts management. Backend is Firebase (Auth + Firestore).

**Tagline:** *Stay Loud. Stay Safe.*
**Partner:** Isibani Foundation (GBV awareness, mental health)

## Commands

```bash
# Setup
flutter clean && flutter pub get

# Code generation (Riverpod, Freezed, JSON serializable) — run after any model/provider change
dart run build_runner build --delete-conflicting-outputs

# Run on specific device
flutter run -d <device-id>
flutter devices  # list connected devices

# Build
flutter build apk --release

# Tests
flutter test
flutter test test/widget_test.dart  # single test file
```

Generated files (`*.g.dart`, `*.freezed.dart`) must never be edited manually — always regenerate with `build_runner`.

## Architecture

Feature-first clean architecture with three layers per feature: `data/`, `domain/`, `presentation/`.

```
lib/
├── core/
│   ├── router/        # GoRouter with auth/panic-state-driven redirects
│   ├── services/      # HapticService, LocationService
│   ├── theme/         # AppTheme (dark theme only, AppTheme.darkTheme / .stealthTheme)
│   └── utils/         # Riverpod & Router loggers
└── features/
    ├── auth/          # Firebase Auth (email/password, email verification)
    ├── panic/         # Core panic flow: state machine, alerts, SMS
    ├── trigger_engine/ # Pluggable trigger abstraction (manual now, BLE Phase 2)
    └── user_profile/  # Contacts, medical profile, settings, onboarding
```

### State Management

Riverpod with code generation (`@riverpod` annotation). All providers use `riverpod_annotation` — never write providers manually.

### Panic Flow (core feature)

`PanicState` is a Freezed sealed class with states: `idle → armed → countingDown → active | cancelled | error`.

The `PanicNotifier` listens to a `PanicTriggerService` stream. For MVP, `ManualPanicTriggerService` is used; `BlePanicTriggerService` is planned for Phase 2. The trigger engine is abstracted via `PanicTriggerService` (abstract class in `trigger_engine/`) — swap implementations by changing `activeTriggerServiceProvider`.

On panic activation: location is fetched → contacts loaded → SMS sent via `url_launcher` → alert written to Firestore.

### Routing

`goRouterProvider` watches three states and redirects accordingly:
1. **Not logged in** → `/login`
2. **Logged in, email unverified** → `/verify-email`
3. **Verified, profile incomplete** → `/onboarding`
4. **Panic state** → `/countdown` or `/alert-active` (overrides all other navigation)

Route constants live in `AppRoutes` class (`core/router/app_router.dart`).

### Data Models

All entities use `@freezed` + `@JsonSerializable`. Run `build_runner` after any changes to models or annotated providers.

### Theme

App uses a single dark theme (`AppTheme.darkTheme`). A stealth variant (`AppTheme.stealthTheme`) with pure black background is used on the Alert Active screen. All colors are defined as static constants on `AppTheme` — use those, never raw hex literals.

## Firebase Setup

Requires `google-services.json` in `android/app/` for Android. `Firebase.initializeApp()` is called in `main()` with no options (relies on the native config file). There is no `firebase_options.dart` — don't generate one unless explicitly asked.

## Brand Identity (App)

The app uses a **dark emergency theme** independent of the marketing brand palette:
- Primary: `#E53935` (red)
- Background: `#0D0D0D`
- Surface: `#1A1A1A` / Card: `#252525`

The pink brand palette (`#E58090`, `#EFB2BA`, etc.) from the Brand Guidelines is for physical product and marketing materials only — not for the app UI.
