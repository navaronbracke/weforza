import 'package:weforza/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class RideListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.directions_bike,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(S.of(context).ListEmpty),
          ),
        ],
      ),
    );
  }
}
