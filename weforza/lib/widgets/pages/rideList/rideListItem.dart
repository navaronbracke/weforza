import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/common/rideAttendeeCounter.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a single item for the ride list page.
class RideListItem extends StatelessWidget
    implements PlatformAwareWidget, PlatformAndOrientationAwareWidget {
  RideListItem(this.ride, this._onTap) : assert(ride != null && _onTap != null);

  final Ride ride;

  final VoidCallback _onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: PlatformAwareWidgetBuilder.build(context, this),
        onTap: _onTap,
      );

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(
        context,
        buildAndroidPortraitLayout(context),
        buildAndroidLandscapeLayout(context));
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return OrientationAwareWidgetBuilder.build(context,
        buildIOSPortraitLayout(context), buildIOSLandscapeLayout(context));
  }

  @override
  Widget buildAndroidLandscapeLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? ListTile(
            title: Row(
              children: <Widget>[
                Text(ride.getFormattedDate(context, false)),
                Expanded(child: Center()),
                RideAttendeeCounter(ride.numberOfAttendees.toString()),
              ],
            ),
          )
        : ListTile(
            title: Text(
              ride.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: <Widget>[
                Text(ride.getFormattedDate(context, false)),
                Expanded(child: Center()),
                RideAttendeeCounter(ride.numberOfAttendees.toString()),
              ],
            ));
  }

  @override
  Widget buildAndroidPortraitLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? ListTile(
            title: Row(
              children: <Widget>[
                Text(ride.getFormattedDate(context, false)),
                Expanded(child: Center()),
                RideAttendeeCounter(ride.numberOfAttendees.toString()),
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
                RideAttendeeCounter(ride.numberOfAttendees.toString()),
              ],
            ));
  }

  @override
  Widget buildIOSLandscapeLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: <Widget>[
                  Text(ride.getFormattedDate(context, false)),
                  Expanded(child: Center()),
                  RideAttendeeCounter("${ride.numberOfAttendees}"),
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16,color: Colors.blue),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Text(ride.getFormattedDate(context, false)),
                      Expanded(child: Center()),
                      RideAttendeeCounter(ride.numberOfAttendees.toString())
                    ],
                  )
                ],
              ),
            ),
          );
  }

  @override
  Widget buildIOSPortraitLayout(BuildContext context) {
    return (ride.title == null || ride.title.isEmpty)
        ? Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: <Widget>[
                  Text(ride.getFormattedDate(context, false)),
                  Expanded(child: Center()),
                  RideAttendeeCounter("${ride.numberOfAttendees}"),
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
                      RideAttendeeCounter(ride.numberOfAttendees.toString())
                    ],
                  )
                ],
              ),
            ),
          );
  }
}
