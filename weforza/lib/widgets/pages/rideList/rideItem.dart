
import 'package:flutter/material.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] represents a [Ride] within the 'Rides' content panel of [RideListPage].
class RideItem extends StatelessWidget implements PlatformAwareWidget {
  RideItem(this._ride): assert(_ride != null);
  ///The [Ride] of this item.
  final Ride _ride;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    //TODO background color states
    return Card(
      color: Color.fromARGB(255, 220, 220, 220),
      child: InkWell(
        onTap: (){
          //TODO
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text("${_ride.getFormattedDate(context)}")
          ),
        ),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //TODO
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text("${_ride.getFormattedDate(context)}")
          ),
        ),
      ),
    );
  }
}