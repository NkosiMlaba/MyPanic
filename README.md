# my_panic

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<!-- Android app running -->
flutter clean
flutter pub get
flutter devices
flutter run -d MPK0222525000545


Current:
App prompts the user to send the SMS
    Can we do whatsapp instead? Or have SMS and whatsapp as options?
    Alternatively have the in app notifications, (which might require a paring thing either QR code or paring code)

Logo of app and name

There's also a current issue where the app does not fetch the database info on a new device (logging in to another one)
    So it must check remote DB then local db, if remote is empty, then local is empty, if remote has data, then local must have data
    Even the 30 second timer was affected, and it would only sync after going to settings
    Like it shouldn't re prompt for your info if you are logging in and already have info in the database

So hardcoding the status values on the home screen like the number of contacts and active location status
