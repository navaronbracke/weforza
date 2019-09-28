# WeForza

This project uses (flutter i18n)[https://plugins.jetbrains.com/plugin/10128-flutter-i18n] for generating i18n-related boilerplate code.

Installation of the plugin is thus required.

## Android

To run an Android emulator,

 - set one up via the AVD Device Manager
 - start the emulator (through the AVD manager)
 - start the app

## IOS

To run an IOS Simulator,

 - run `open -a Simulator` in a terminal, to open the IOS simulator
 - in the flutter project directory, run `flutter run` from the terminal, to run the app

## Integration tests

To run a test,
 - start an Android emulator/IOS Simulator
 - run `flutter drive --target=test_driver/app.dart` and specify the test file with `--driver=path_to_test_file`
   from the project root directory.
 Examples:

 `flutter drive --target=test_driver/app.dart` (assumes the driver is `test_driver/app_test.dart`)
 `flutter drive --target=test_driver/app.dart --driver=test_driver/my_second_test.dart`


