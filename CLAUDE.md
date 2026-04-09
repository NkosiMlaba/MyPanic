# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**MyPanic** — A Flutter personal safety app (Android/iOS) paired with a physical silicone whistle keychain. Manual panic button with countdown, SMS emergency alerts, live location sharing, and trusted contacts management. Backend is Firebase (Auth + Firestore).

**Tagline:** *Stay Loud. Stay Safe.*
**Partner:** Isibani Foundation (GBV awareness, mental health)

## Commands

```bash
# Setup
flutter clean && flutter pub get

# Code generation (Riverpod, Freezed, JSON serializable) — run after any model/provider change
dart run build_runner build --delete-conflicting-outputs

# Run on device
flutter run -d <device-id>
flutter devices  # list connected devices

# Build
flutter build apk --release

# Tests
flutter test
flutter test test/widget_test.dart  # single file
```

Generated files (`*.g.dart`, `*.freezed.dart`) must never be edited manually — always regenerate with `build_runner`.

## Architecture

Feature-first clean architecture with three layers per feature: `data/`, `domain/`, `presentation/`.

```
lib/
├── core/
│   ├── router/        # GoRouter with auth/panic-state-driven redirects
│   ├── services/      # HapticService, LocationService
│   ├── theme/         # AppTheme — brand light theme + emergency dark constants
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

`PanicState` is a Freezed sealed class: `idle → armed → countingDown → active | cancelled | error`.

`PanicNotifier` listens to a `PanicTriggerService` stream. For MVP, `ManualPanicTriggerService` is used; `BlePanicTriggerService` is planned for Phase 2. The trigger engine is abstracted via `PanicTriggerService` (abstract class in `trigger_engine/`) — swap implementations by changing `activeTriggerServiceProvider`.

On panic activation: location fetched → contacts loaded → SMS sent via `url_launcher` → alert written to Firestore.

### Trigger Engine

`PanicTriggerService` is the abstract interface. `TriggerSource` enum: `manual, ble, voice, gesture`. New trigger types (shake, BLE, etc.) implement `PanicTriggerService` and register via `activeTriggerServiceProvider`. The `TriggerEvent` carries timestamp, source, and optional metadata.

### Routing

`goRouterProvider` watches three states and redirects:
1. **Not logged in** → `/login`
2. **Logged in, email unverified** → `/verify-email`
3. **Verified, profile incomplete** → `/onboarding`
4. **Panic state** → `/countdown` or `/alert-active` (overrides all other navigation)

Route constants live in `AppRoutes` class (`core/router/app_router.dart`).

### Data Models

All entities use `@freezed` + `@JsonSerializable`. Run `build_runner` after any changes to models or annotated providers.

### Theme

App uses a **brand light theme** (`AppTheme.brandTheme`, `Brightness.light`) as the default. `AppTheme.darkTheme` is an alias for `brandTheme` — do not use it expecting dark.

**Brand (light) surfaces:** `backgroundBrand` (blush `#FEEEE`), `surfaceBrand` (white), `cardBrand` (white), text colors `brandCharcoal`/`brandWarmGrey`/`textBrandMuted`.

**Emergency (dark) constants — used ONLY in `countdown_screen.dart` and `alert_active_screen.dart`:** `backgroundDark` (`#0D0D0D`), `surfaceDark`, `cardDark`, `countdownBackground`. These screens override `Scaffold.backgroundColor` directly.

Color rules:
- `brandPink` (`#E58090`) — all buttons, inputs, accents, section titles
- `emergencyRed` (`#E53935`) — **only** in `panic_button_widget.dart`
- `errorRed` (`#F44336`) — countdown and alert-active screens
- All colors are static constants on `AppTheme` — never use raw hex literals

## Firebase Setup

Requires `google-services.json` in `android/app/` for Android (not committed). `Firebase.initializeApp()` in `main()` with no options — relies on native config file. There is no `firebase_options.dart` — don't generate one unless explicitly asked.

## Brand Identity

Logo assets in `assets/images/` (declared in `pubspec.yaml`):
- `MyPanic-logo-text-normal.png` — full color logo with brush stroke — auth screens
- `MyPanic-logo-heart.png` — hugging heart icon — home header, onboarding, verify email
- `MyPanic-logo-text-monochrome.png` — black version, reserved for light backgrounds

Brand docs in `Docs/` (DESIGN_REFERENCE.md, brand guidelines PDF).

## Android Permissions (current)

`ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION`, `VIBRATE`, `CALL_PHONE` — declared in `AndroidManifest.xml`. SMS uses `url_launcher` intent (no `SEND_SMS` permission needed).
