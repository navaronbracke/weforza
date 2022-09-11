import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a platform aware, indeterminate, loading indicator.
class PlatformAwareLoadingIndicator extends StatelessWidget {
  const PlatformAwareLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => const CircularProgressIndicator(),
      ios: () => const CupertinoActivityIndicator(),
    );
  }
}
