import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget {
  RideListItem({@required this.ride, this.onPressed, this.rideAttendeeFuture}):
        assert(ride != null && rideAttendeeFuture != null && onPressed != null);

  final Ride ride;

  final void Function(Future<int> attendeeFuture, Ride ride) onPressed;

  final Future<int> rideAttendeeFuture;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: PlatformAwareWidget(
          android: () => _buildAndroidLayout(context),
          ios: () => _buildIOSLayout(context),
        ),
    //Pass the still running future to the on tap, so we can wait for it to finish in the detail page.
    onTap: () => onPressed(rideAttendeeFuture, ride),
  );

  Widget _buildAndroidLayout(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(ride.getFormattedDate(context, false)),
          Expanded(child: Center()),
          RideAttendeeCounter(future: rideAttendeeFuture),
        ],
      ),
    );
  }

  Widget _buildIOSLayout(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: <Widget>[
            Text(ride.getFormattedDate(context, false)),
            Expanded(child: Center()),
            RideAttendeeCounter(future: rideAttendeeFuture),
          ],
        ),
      ),
    );
  }
}
