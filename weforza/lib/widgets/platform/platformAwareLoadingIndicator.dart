
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This widget is a platform aware loading indicator set to indeterminate.
class PlatformAwareLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => CircularProgressIndicator(value: null),
    ios: () => CupertinoActivityIndicator(),
  );
}