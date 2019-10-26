
import 'package:flutter/cupertino.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a page where one or more rides can be added.
class AddRidePage extends StatefulWidget {
  @override
  _AddRidePageState createState() => _AddRidePageState();
}

///This class is the State for [AddRidePage].
class _AddRidePageState extends State<AddRidePage> implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context)
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context),
        buildIOSLandscapeLayout(context)
    );
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    // TODO: implement buildAndroidLandscapeLayout
    return null;
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    // TODO: implement buildAndroidPortraitLayout
    return null;
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    // TODO: implement buildIOSLandscapeLayout
    return null;
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    // TODO: implement buildIOSPortraitLayout
    return null;
  }
}
