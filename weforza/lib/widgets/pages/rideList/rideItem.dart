
import 'package:flutter/material.dart';
import 'package:weforza/blocs/rideListRideItemBloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/theme/appTheme.dart';
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

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Card(
      color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedColor : ApplicationTheme.rideListItemUnselectedColor,
      elevation: 4.0,
      child: InkWell(
        splashColor: ApplicationTheme.rideListItemSplashColor,
        onTap: (){
          //TODO
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text(widget.bloc.getFormattedDate(context),style:
              TextStyle(color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor),)
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
        color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedColor : ApplicationTheme.rideListItemUnselectedColor,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text(widget.bloc.getFormattedDate(context),style:
              TextStyle(color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor),)
          ),
        ),
      ),
    );
  }
}