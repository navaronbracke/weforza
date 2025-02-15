import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a platform aware indefinite progress indicator
/// with a label underneath.
class ProgressIndicatorWithLabel extends StatelessWidget {
  const ProgressIndicatorWithLabel({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(label, style: TextTheme.of(context).labelMedium),
            ),
          ],
        );
      },
      ios: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(),
            Padding(padding: const EdgeInsets.only(top: 8), child: Text(label)),
          ],
        );
      },
    );
  }
}
