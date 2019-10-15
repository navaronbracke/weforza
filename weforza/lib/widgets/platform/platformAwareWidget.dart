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
  static Widget build(BuildContext context, PlatformAwareWidget builder){
    if (Platform.isAndroid) {
      return builder.buildAndroidWidget(context);
    } else if (Platform.isIOS) {
      return builder.buildIosWidget(context);
    }
    return null;
  }

}

///This class will build orientation specific variants of [Widget]s.
abstract class OrientationAwareWidgetBuilder {

  ///Build an orientation adaptive [Widget].
  ///Returns [portrait] when in [Orientation.portrait].
  ///Returns [landscape] otherwise.
  static Widget build(BuildContext context,Widget portrait,Widget landscape){
    assert(portrait != null && landscape != null);
    return OrientationBuilder(
      builder: (context,orientation){
        if(orientation == Orientation.portrait){
          return portrait;
        }else {
          return landscape;
        }
      },
    );
  }
}

///This class represents an interface for platform specific [Widget] building.
abstract class PlatformAwareWidget {

  ///Build a [Widget] that is tailored to Android.
  Widget buildAndroidWidget(BuildContext context);

  ///Build a [Widget] that is tailored to IOS.
  Widget buildIosWidget(BuildContext context);
}

///This class defines a contract for [Widget]s,
///that build differently per platform and orientation at the same time.
abstract class PlatformAndOrientationAwareWidget {

  ///Build a portrait layout for Android.
  Widget buildAndroidPortraitLayout(BuildContext context);
  ///Build a landscape layout for Android.
  Widget buildAndroidLandscapeLayout(BuildContext context);
  ///Build a portrait layout for IOS.
  Widget buildIOSPortraitLayout(BuildContext context);
  ///Build a landscape layout for IOS.
  Widget buildIOSLandscapeLayout(BuildContext context);
}