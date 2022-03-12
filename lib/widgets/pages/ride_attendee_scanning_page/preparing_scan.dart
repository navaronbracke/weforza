import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class PreparingScanWidget extends StatelessWidget {
  const PreparingScanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const PlatformAwareLoadingIndicator(),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(S.of(context).RideAttendeeScanningPreparingScan),
        ),
      ],
    );
  }
}
