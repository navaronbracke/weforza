import 'package:weforza/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

class RideListError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          SizedBox(height: 5),
          Text(S.of(context).RideListLoadingRidesError)
        ],
      ),
    );
  }
}
