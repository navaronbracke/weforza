

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget implements PlatformAwareWidget {
  RideListItem(this.ride): assert(ride != null);

  final Ride ride;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: PlatformAwareWidgetBuilder.build(context, this)
  );

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Text(ride.getFormattedDate(context)),
          Expanded(child: Center()),
          Row(
            children: <Widget>[
              Text("${ride.numberOfAttendees}"),
              SizedBox(width: 4),
              Icon(Icons.people),
            ],
          ),
        ],
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
                Text("${ride.numberOfAttendees}"),
                SizedBox(width: 4),
                Icon(Icons.people),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
