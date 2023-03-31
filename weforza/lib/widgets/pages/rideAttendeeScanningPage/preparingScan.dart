import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class PreparingScanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      PlatformAwareLoadingIndicator(),
      SizedBox(height: 20),
      Text(S.of(context).RideAttendeeScanningPreparingScan),
    ],
  );
}
