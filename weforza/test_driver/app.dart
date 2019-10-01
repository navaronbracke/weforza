import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:weforza/injection/injector.dart';
import 'package:weforza/main.dart' as app;

///This file enables the Flutter Driver extension,
///thus making an instrumented version of the app.
void main() {
  enableFlutterDriverExtension();

  //Don't forget to set up the injector.
  InjectionContainer.initTestInjector();

  // Call the `main()` function of the app, or call `runApp` with
  // any widget you are interested in testing.
  runApp(app.WeForzaApp());
}