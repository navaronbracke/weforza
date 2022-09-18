import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/widgets/platform/platform_aware_icon.dart';

class RideDetailsAttendeesListEmpty extends StatelessWidget {
  const RideDetailsAttendeesListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareIcon(
            androidIcon: Icons.people,
            iosIcon: CupertinoIcons.person_2_fill,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(S.of(context).RideDetailsNoAttendees),
          ),
        ],
      ),
    );
  }
}
