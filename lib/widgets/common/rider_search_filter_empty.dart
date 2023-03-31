import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

class RiderSearchFilterEmpty extends StatelessWidget {
  const RiderSearchFilterEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        PlatformAwareIcon(
          androidIcon: Icons.people,
          iosIcon: CupertinoIcons.person_2_fill,
          size: MediaQuery.of(context).size.shortestSide * .1,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 16, right: 16),
          child: Text(
            S.of(context).searchRidersEmpty,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
