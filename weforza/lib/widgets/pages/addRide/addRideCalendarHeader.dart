
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarPaginator.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents the header for the ride calendar in [AddRidePage].
class AddRideCalendarHeader extends StatelessWidget {
  AddRideCalendarHeader(this.paginator): assert(paginator != null);

  final IAddRideCalendarPaginator paginator;

  @override
  Widget build(BuildContext context) => PlatformAwareWidget(
    android: () => _buildAndroidWidget(context),
    ios: () => _buildIosWidget(context),
  );

  Widget _buildAndroidWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: ApplicationTheme.rideCalendarHeaderButtonIdleColor,
          splashColor: ApplicationTheme.rideCalendarHeaderButtonOnPressedColor,
          onPressed: () => paginator.pageBack(),
        ),
        Expanded(
          child: Center(
            child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                .languageCode)
                .add_y()
                .format(paginator.pageDate),
              style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: ApplicationTheme.rideCalendarHeaderButtonIdleColor,
          splashColor: ApplicationTheme.rideCalendarHeaderButtonOnPressedColor,
          onPressed: () => paginator.pageForward(),
        ),
      ],
    );
  }

  Widget _buildIosWidget(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).orientation == Orientation.portrait ?  const EdgeInsets.symmetric(vertical: 40,horizontal: 20): const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          CupertinoIconButton(
              Icons.arrow_back_ios,
              ApplicationTheme.rideCalendarHeaderButtonIdleColor,
              ApplicationTheme.rideCalendarHeaderButtonOnPressedColor, () => paginator.pageBack()),
          Expanded(
            child: Center(
              child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                  .languageCode)
                  .add_y()
                  .format(paginator.pageDate),
                style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
              ),
            ),
          ),
          CupertinoIconButton(
              Icons.arrow_forward_ios,
              ApplicationTheme.rideCalendarHeaderButtonIdleColor,
              ApplicationTheme.rideCalendarHeaderButtonOnPressedColor, () => paginator.pageForward()),
        ],
      ),
    );
  }

}