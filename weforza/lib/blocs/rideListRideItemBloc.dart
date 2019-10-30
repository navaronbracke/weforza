
import 'package:flutter/cupertino.dart';
import 'package:weforza/blocs/bloc.dart';
import 'package:weforza/model/ride.dart';

///This class represents a BLoC for a RideItem in RideListPage.
class RideListRideItemBloc extends Bloc {
  RideListRideItemBloc(this._ride,this.isSelected): assert(_ride != null && isSelected != null);

  ///Whether this item is selected.
  bool isSelected;

  ///The internal ride object.
  final Ride _ride;


  String getFormattedDate(BuildContext context){
    assert(context != null);
    return _ride.getFormattedDate(context);
  }

  @override
  void dispose() {}

}