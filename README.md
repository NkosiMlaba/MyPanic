# MyPanic

A Flutter panic-button app. Auth via **Supabase**; alerts and contacts ride
on top of **`MyPanic.Api`** (the .NET 8 backend in the sibling repo).
SMS fan-out happens server-side via SMSFlow + Hangfire.

## Run

The Dart entrypoint reads three values via `--dart-define`. Without them,
`ApiOptions.assertConfigured()` throws at boot.

```
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs

flutter run -d <device-id> \
  --dart-define=SUPABASE_URL=https://<your-project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ... \
  --dart-define=MYPANIC_API_BASE_URL=http://10.0.2.2:5187
```

`MYPANIC_API_BASE_URL` per environment:
- **Android emulator** → `http://10.0.2.2:5187` (10.0.2.2 is how the
  emulator reaches the dev machine's localhost).
- **Real device on the same Wi-Fi** → `http://<dev-LAN-IP>:5187`
  (e.g. `http://192.168.1.50:5187`). Open Windows Defender Firewall to
  allow inbound 5187 on private networks.
- **Production** → whatever the deployed `MyPanic.Api` URL is.

`flutter devices` lists attached devices. Convenience IDs we use:

```
flutter run -d MPK0222525000545   # Huawei
flutter run -d RFCR902H1GE        # Samsung
flutter run -d R7AWB0CBM7A        # Samsung (Ayanda)
```

## Auth deep links

Password-reset and email-confirmation links round-trip through the OS as
deep links on the scheme `io.kizuri.mypanic://auth-callback`. Two pieces
must be in place:

1. The Android intent-filter (already in `android/app/src/main/AndroidManifest.xml`).
2. **One-time Supabase Studio config:** in your project, go to
   *Authentication → URL Configuration* and add
   `io.kizuri.mypanic://auth-callback` to the Redirect URLs allow-list.

Without #2, Supabase silently rewrites the redirect to its default and the
app never sees the callback.

## Tests

```
flutter test \
  --dart-define=MYPANIC_API_BASE_URL=http://test.local \
  --dart-define=SUPABASE_URL=http://test.local \
  --dart-define=SUPABASE_ANON_KEY=test-key
```

21 unit tests covering all 15 paths in the migration plan's coverage
diagram. The dart-defines are required because `ApiOptions` is read via
`String.fromEnvironment` and `MyPanicApiClient` parses the URL at request
time — empty strings break `Uri.parse`.

## Backlog (UI/UX, not blocking)

- SMS vs WhatsApp toggle (consider QR / pairing code for in-app notifications).
- App icon + display name pass.
- Hardware-button trigger (e.g. volume-up combo) on Android.
- Replace hard-coded status values on the home screen (active-contact count,
  location status).
- Plug back the dropped fields when the API extends `ProfileResponse`:
  medications, emergencyNotes, insuranceInfo, doctorName, doctorPhone,
  countdownDuration. Currently the UI text fields render but the typed
  values don't persist (Task 6 trade-off).
