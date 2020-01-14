

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget implements PlatformAwareWidget {
  RideListItem(this.ride,this.onTap): assert(ride != null && onTap != null);

  final Ride ride;
  final Function(Ride ride) onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: PlatformAwareWidgetBuilder.build(context, this),
    onTap: onTap(ride),
  );

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(ride.getFormattedDate(context)),
            Expanded(child: Center()),
            Row(
              children: <Widget>[
                Icon(Icons.people),
                SizedBox(
                  child: Center(child: Text("${ride.numberOfAttendees}")),
                  width: 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(ride.getFormattedDate(context)),
            Expanded(child: Center()),
            Row(
              children: <Widget>[
                Icon(Icons.people),
                SizedBox(
                  child: Center(child: Text("${ride.numberOfAttendees}")),
                  width: 60,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
