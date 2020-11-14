import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget {
  RideListItem({
    @required this.ride,
    @required this.rideAttendeeFuture,
    this.onPressed,
  }): assert(ride != null && rideAttendeeFuture != null && onPressed != null);

  final Ride ride;

  final void Function(Future<int> attendeeFuture, Ride ride) onPressed;

  final Future<int> rideAttendeeFuture;

  @override
  Widget build(BuildContext context){
    final Color textColor = ride.date.month % 2 == 0 ?
      ApplicationTheme.rideListItemEvenMonthColor:
      ApplicationTheme.rideListItemOddMonthColor;

    final textStyle = TextStyle(color: textColor);

    final content = Row(
      children: <Widget>[
        Expanded(
            child: Text(
              ride.getFormattedDate(context, false),
              style: textStyle
          ),
        ),
        RideAttendeeCounter(
            future: rideAttendeeFuture,
            counterStyle: textStyle
        ),
      ],
    );

    return GestureDetector(
      child: PlatformAwareWidget(
        android: () => ListTile(title: content),
        ios: () => Container(
          decoration: BoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: content,
          ),
        ),
      ),
      // Pass the still running future to the on tap, so we can wait for it to finish in the detail page.
      onTap: () => onPressed(rideAttendeeFuture, ride),
    );
  }
}
