
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weforza/blocs/addRideBloc.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/addRide/addRideCalendarPaginator.dart';
import 'package:weforza/widgets/platform/cupertinoIconButton.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents the header for the ride calendar in [AddRidePage].
class AddRideCalendarHeader extends StatefulWidget  {
  AddRideCalendarHeader(this.paginator): assert(paginator != null);

  final IAddRideCalendarPaginator paginator;

  ///[AddRideBloc] implements the paginator
  @override
  _AddRideCalendarHeaderState createState() => _AddRideCalendarHeaderState();
}

class _AddRideCalendarHeaderState extends State<AddRideCalendarHeader> implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: ApplicationTheme.rideCalendarHeaderButtonIdleColor,
          splashColor: ApplicationTheme.rideCalendarHeaderButtonOnPressedColor,
          onPressed: (){
            setState(() {
              widget.paginator.pageBack();
            });
          },
        ),
        Expanded(
          child: Center(
            child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                .languageCode)
                .add_y()
                .format(widget.paginator.pageDate),
              style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: ApplicationTheme.rideCalendarHeaderButtonIdleColor,
          splashColor: ApplicationTheme.rideCalendarHeaderButtonOnPressedColor,
          onPressed: (){
            setState(() {
              widget.paginator.pageForward();
            });
          },
        ),
      ],
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        CupertinoIconButton(
            Icons.arrow_back_ios,
            ApplicationTheme.rideCalendarHeaderButtonIdleColor,
            ApplicationTheme.rideCalendarHeaderButtonOnPressedColor, (){
              setState(() {
            widget.paginator.pageBack();
          });
        }),
        Expanded(
          child: Center(
            child: Text(DateFormat.MMMM(Localizations.localeOf(context)
                .languageCode)
                .add_y()
                .format(widget.paginator.pageDate),
              style: TextStyle(color: ApplicationTheme.rideCalendarHeaderColor),
            ),
          ),
        ),
        CupertinoIconButton(
            Icons.arrow_back_ios,
            ApplicationTheme.rideCalendarHeaderButtonIdleColor,
            ApplicationTheme.rideCalendarHeaderButtonOnPressedColor, (){
          setState(() {
            widget.paginator.pageForward();
          });
        }),
      ],
    );
  }
}