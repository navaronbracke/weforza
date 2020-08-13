import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/common/memberWithPictureListItem.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesListEmpty.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class RideDetailsAttendeesList extends StatelessWidget {
  RideDetailsAttendeesList({@required this.future}): assert(future != null);

  final Future<List<MemberItem>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MemberItem>>(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            return GenericError(
                text: S.of(context).RideDetailsLoadAttendeesError
            );
          } else {
            if (snapshot.data == null || snapshot.data.isEmpty) {
              return RideDetailsAttendeesListEmpty();
            } else {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    return MemberWithPictureListItem(item: snapshot.data[index]);
                  },
                  itemCount: snapshot.data.length);
            }
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
