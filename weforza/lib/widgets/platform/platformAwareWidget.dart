import 'dart:io';

import 'package:flutter/widgets.dart';

///This [Widget] checks the [Platform] and returns an appropriate [Widget].
///The functions for [android] and [ios] must not be null.
///The [platformHandler] must not be null.
///
///Only supports Android and IOS for now.
///This may change when support for the web and or desktop enters stable.
class PlatformAwareWidget extends StatelessWidget {
  PlatformAwareWidget({
    required this.android,
    required this.ios,
    this.platformHandler = const PlatformAwareWidgetPlatformChecker(),
    Key? key,
  }): super(key: key);

  ///The [Widget] builder for Android.
  final Widget Function() android;
  ///The [Widget] builder for IOS.
  final Widget Function() ios;

  ///The [PlatformAwareWidgetPlatformChecker] that will handle the [Platform] checks.
  final PlatformAwareWidgetPlatformChecker platformHandler;


  ///Build the [Widget].
  ///Returns the result of calling [android] when [platformHandler.isAndroid] is true.
  ///Returns the result of calling [ios] when [platformHandler.isIOS] is true.
  ///
  ///Using this method on unsupported [Platform]s results in a [FlutterError].
  @override
  Widget build(BuildContext context) {
    if(platformHandler.isAndroid){
      return android();
    }
    if(platformHandler.isIOS){
      return ios();
    }

    throw FlutterError("Cannot build for an unsupported platform.");
  }
}

///This class will perform the [Platform] checks for [PlatformAwareWidget].
///If it is desired to mock the [Platform],
///this class can be subclassed and injected into [PlatformAwareWidget].
class PlatformAwareWidgetPlatformChecker {
  const PlatformAwareWidgetPlatformChecker();

  ///Check if the [Platform] is Android.
  bool get isAndroid => Platform.isAndroid;

  ///Check if the [Platform] is IOS.
  bool get isIOS => Platform.isIOS;

  ///Check if the [Platform] is Windows.
  bool get isWindows => Platform.isWindows;

  ///Check if the [Platform] is Mac OSX.
  bool get isMacOS => Platform.isMacOS;

  ///Check if the [Platform] is Linux.
  bool get isLinux => Platform.isLinux;

  ///Check if the [Platform] is Fuchsia.
  bool get isFuchsia => Platform.isFuchsia;
}
