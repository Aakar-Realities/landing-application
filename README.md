# Aakar Realities Flutter app

The Flutter app displays the Aakar Realities website in a native WebView,
supports Android back navigation through website history, and shows a retry
screen when the main page cannot load.

## Set up Flutter

Install Flutter 3.38 or newer and the Android SDK. On Windows, the Flutter
extension in VS Code can install the Flutter SDK; install Android Studio to
set up the Android SDK and emulator.

From the project root, generate the Flutter platform folders and install
dependencies:

```powershell
flutter create --platforms=android,ios --org com.aakarrealities --project-name workspace .
flutter pub get
dart run flutter_launcher_icons
```

The generated Android application ID is `com.aakarrealities.workspace`.

## Run the app

Start an Android emulator or connect an Android device, then run:

```powershell
flutter run
```

## Build an APK

```powershell
flutter build apk --release
```

The installable APK is written to
`build/app/outputs/flutter-apk/app-release.apk`.
