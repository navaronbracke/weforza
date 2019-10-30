
import 'package:flutter/material.dart';
import 'package:weforza/blocs/rideListRideItemBloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a [Ride] within the 'Rides' content panel of [RideListPage].
class RideItem extends StatefulWidget {
  RideItem(this.bloc): assert(bloc != null);

  ///The [Ride] of this item.
  final RideListRideItemBloc bloc;

  @override
  State<StatefulWidget> createState() => _RideItemState();
}

class _RideItemState extends State<RideItem> implements PlatformAwareWidget {

  //(un)select

  Color _backgroundColor;
  Color _fontColor;
  Color _splashColor;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    //TODO background color states
    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: (){
          //TODO
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text(widget.bloc.getFormattedDate(context))
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
              child: Text(widget.bloc.getFormattedDate(context))
          ),
        ),
      ),
    );
  }
}