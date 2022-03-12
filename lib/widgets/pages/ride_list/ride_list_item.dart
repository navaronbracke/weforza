import 'package:flutter/material.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/ride_attendee_counter.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget {
  const RideListItem({
    Key? key,
    required this.ride,
    required this.rideAttendeeFuture,
    required this.onPressed,
  }) : super(key: key);

  final Ride ride;

  final void Function(Future<int> attendeeFuture, Ride ride) onPressed;

  final Future<int> rideAttendeeFuture;

  @override
  Widget build(BuildContext context) {
    final textStyle = ride.date.month % 2 == 0
        ? const TextStyle(
            color: ApplicationTheme.rideListItemEvenMonthColor,
          )
        : const TextStyle();

    final content = Row(
      children: <Widget>[
        Expanded(
          child: Text(ride.getFormattedDate(context, false), style: textStyle),
        ),
        RideAttendeeCounter(
            future: rideAttendeeFuture, counterStyle: textStyle),
      ],
    );

    return GestureDetector(
      child: PlatformAwareWidget(
        android: () => ListTile(title: content),
        ios: () => Container(
          decoration: const BoxDecoration(),
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