import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget implements PlatformAwareWidget {
  RideListItem(this.ride,this._onTap): assert(ride != null && _onTap != null);

  final Ride ride;

  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: PlatformAwareWidgetBuilder.build(context, this),
    onTap: _onTap,
  );

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(ride.getFormattedDate(context)),
          Expanded(child: Center()),
          RideAttendeeCounter(ride.numberOfAttendees.toString()),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: <Widget>[
            Text(ride.getFormattedDate(context)),
            Expanded(child: Center()),
            Row(
              children: <Widget>[
                Text("${ride.numberOfAttendees}"),
                SizedBox(width: 5),
                Icon(Icons.people,color: ApplicationTheme.rideAttendeeCounterIconColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
