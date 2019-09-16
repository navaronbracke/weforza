import 'package:flutter/widgets.dart';
import 'dart:io' show Platform;

///This class will build platform specific variants of [Widget]s.
abstract class PlatformAwareWidgetBuilder {

  ///Build a [Widget] that is tailored to the platform.
  ///
  ///The [builder] will construct the requested [Widget].
  ///
  ///Returns a platform tailored [Widget] if the platform is Android or IOS.
  ///Otherwise returns null.
  static Widget buildPlatformAwareWidget(BuildContext context, PlatformAwareWidget builder){
    if (Platform.isAndroid) {
      return builder.buildAndroidWidget(context);
    } else if (Platform.isIOS) {
      return builder.buildIosWidget(context);
    }
    return null;
  }

}

///This class represents an interface for platform specific [Widget] building.
abstract class PlatformAwareWidget {

  ///Build a [Widget] that is tailored to Android.
  Widget buildAndroidWidget(BuildContext context);

  ///Build a [Widget] that is tailored to IOS.
  Widget buildIosWidget(BuildContext context);
}