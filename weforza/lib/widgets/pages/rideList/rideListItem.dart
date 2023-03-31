import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget {
  RideListItem(this.ride, this._onTap): assert(ride != null && _onTap != null);

  final Ride ride;

  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    child: PlatformAwareWidget(
          android: () => _buildAndroidLayout(context),
          ios: () => _buildIOSLayout(context),
        ),
    onTap: _onTap,
  );

  Widget _buildAndroidLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? ListTile(
            title: Row(
              children: <Widget>[
                Text(ride.getFormattedDate(context, false)),
                Expanded(child: Center()),
                RideAttendeeCounter(count: ride.numberOfAttendees.toString()),
              ],
            ),
          )
        : ListTile(
            title: Text(
              ride.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: <Widget>[
                Text(ride.getFormattedDate(context, false)),
                Expanded(child: Center()),
                RideAttendeeCounter(count: ride.numberOfAttendees.toString()),
              ],
            ));
  }

  Widget _buildIOSLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: <Widget>[
                  Text(ride.getFormattedDate(context, false)),
                  Expanded(child: Center()),
                  RideAttendeeCounter(count: ride.numberOfAttendees.toString()),
                ],
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ride.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16,color: Colors.blue),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(ride.getFormattedDate(context, false)),
                      Expanded(child: Center()),
                      RideAttendeeCounter(count: ride.numberOfAttendees.toString())
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
