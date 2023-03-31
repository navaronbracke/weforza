import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/widgets/common/genericError.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesListEmpty.dart';
import 'package:weforza/widgets/pages/rideDetails/rideDetailsAttendees/rideDetailsAttendeesListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class RideDetailsAttendeesList extends StatelessWidget {
  RideDetailsAttendeesList({
    required this.future
  });

  final Future<List<Member>>? future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
      future: future,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError) {
            return GenericError(text: S.of(context).GenericError);
          } else {
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return RideDetailsAttendeesListEmpty();
            } else {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    final member = snapshot.data![index];
                    return RideDetailsAttendeesListItem(
                      firstName: member.firstname,
                      lastName: member.lastname,
                      alias: member.alias,
                    );
                  },
                  itemCount: snapshot.data!.length,
              );
            }
          }
        }else{
          return Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}
