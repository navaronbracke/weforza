
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents an error [Widget] for the 'Rides' section of [RideListPage].
class RideListRidesError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).RideListLoadingRidesFailed),
    );
  }
}