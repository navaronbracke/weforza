import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///This widget is a platform aware loading indicator set to indeterminate.
class PlatformAwareLoadingIndicator extends StatelessWidget {
  const PlatformAwareLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => const CircularProgressIndicator(),
      ios: () => const CupertinoActivityIndicator(),
    );
  }
}
