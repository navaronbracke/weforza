
import 'package:flutter/material.dart';
import 'package:weforza/blocs/rideListRideItemBloc.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideList/rideListSelector.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] represents a [Ride] within the 'Rides' content panel of [RideListPage].
class RideItem extends StatefulWidget {
  RideItem(this.bloc,this.selector): assert(bloc != null && selector != null);

  ///The [Ride] of this item.
  final RideListRideItemBloc bloc;

  ///The selection handler.
  final IRideSelector selector;

  @override
  State<StatefulWidget> createState() => _RideItemState();
}

class _RideItemState extends State<RideItem> implements PlatformAwareWidget, IRideSelectable {

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
          widget.selector.selectRide(this);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
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
        widget.selector.selectRide(this);
      },
      child: Container(
        color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedColor : ApplicationTheme.rideListItemUnselectedColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
          child: Center(
              child: Text(widget.bloc.getFormattedDate(context),style:
              TextStyle(color: widget.bloc.isSelected ? ApplicationTheme.rideListItemSelectedFontColor : ApplicationTheme.rideListItemUnselectedFontColor),)
          ),
        ),
      ),
    );
  }

  @override
  void select() {
    if(mounted){
      setState(() {
        widget.bloc.isSelected = !widget.bloc.isSelected;
      });
    }
  }

  @override
  DateTime getDate() => widget.bloc.getDate();

  @override
  bool isAttendeeOf(Attendee attendee) => widget.bloc.isAttendee(attendee);

  @override
  void add(Attendee attendee) => widget.bloc.add(attendee);

  @override
  void remove(Attendee attendee) => widget.bloc.remove(attendee);

  @override
  Ride getRide() => widget.bloc.ride;
}