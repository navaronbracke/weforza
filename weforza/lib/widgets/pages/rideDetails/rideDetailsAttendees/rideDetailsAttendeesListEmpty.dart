import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideDetailsAttendeesListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareWidget(
            android: () => Icon(
              Icons.people,
              color: ApplicationTheme.listInformationalIconColor,
              size: MediaQuery.of(context).size.shortestSide * .1,
            ),
            ios: () => Icon(
              CupertinoIcons.person_2_fill,
              color: ApplicationTheme.listInformationalIconColor,
              size: MediaQuery.of(context).size.shortestSide * .1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(S.of(context).RideDetailsNoAttendees),
          ),
        ],
      ),
    );
  }
}