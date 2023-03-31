import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

class RideListEmpty extends StatelessWidget {
  const RideListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareIcon(
            androidIcon: Icons.directions_bike,
            iosIcon: Icons.directions_bike,
            size: MediaQuery.sizeOf(context).shortestSide * .1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 16, left: 16),
            child: Text(S.of(context).noRides, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
