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

flutter run -d RFCR902H1GE

<!--  -->
flutter run -d R7AWB0CBM7A



Current:
App prompts the user to send the SMS
    Can we do whatsapp instead? Or have SMS and whatsapp as options?
    Alternatively have the in app notifications, (which might require a paring thing either QR code or paring code)

Logo of app and name

There's also a current issue where the app does not fetch the database info on a new device (logging in to another one)
    So it must check remote DB to use that data then local db must be updated. If remote is empty, then local is used (if it exists, user logged out of the app in their device, and logged in again). If both empty, then prompt user to enter info.
    Even the 30 second timer was affected, and it would only sync to reflect the remote data after going to settings
    Like it shouldn't re prompt for your info if you are logging in (new device or relogging in on the same device) and already have info in the database either in the cloud or local. Where cloud data is prioritized over local data.

So hardcoding the status values on the home screen like the number of contacts and active location status
