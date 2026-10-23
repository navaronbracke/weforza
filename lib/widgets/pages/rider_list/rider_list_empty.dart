import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

class RiderListEmpty extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: <Widget>[
        PlatformAwareIcon(
          androidIcon: Icons.people,
          iosIcon: CupertinoIcons.person_2_fill,
          size: MediaQuery.sizeOf(context).shortestSide * .1,
        ),
        Padding(
          padding: const .only(top: 4, left: 16, right: 16),
          child: Text(S.of(context).noRiders, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
