
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This widget is a platform aware loading indicator set to indeterminate.
class PlatformAwareLoadingIndicator extends StatelessWidget implements PlatformAwareWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) => CircularProgressIndicator(value: null);

  @override
  Widget buildIosWidget(BuildContext context) => CupertinoActivityIndicator();

}