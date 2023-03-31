
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:weforza/injection/injectionContainer.dart';
import 'package:weforza/main.dart' as app;

///This file enables the Flutter Driver extension,
///thus making an instrumented version of the app.
void main() {
  enableFlutterDriverExtension();

  //Don't forget to set up the injector.
  InjectionContainer.initTestInjector();

  //Start the app.
  runApp(app.WeForzaApp());
}