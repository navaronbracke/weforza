
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents an empty list [Widget] for the 'Rides' section of [RideListPage].
class RideListRidesEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(S.of(context).RideListNoRides),
            SizedBox(height: 10),
            Text(S.of(context).RideListAddRideInstruction),
            Text(S.of(context).RideListAddRideInstructionPlus),
          ],
        ),
      ),
    );
  }
}