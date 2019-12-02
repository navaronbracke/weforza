
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents an empty list [Widget] for the 'Members' section of [RideListPage].
class RideListMembersEmpty extends StatelessWidget {
  RideListMembersEmpty(this.filterIsEnabled): assert(filterIsEnabled != null);

  final bool filterIsEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(filterIsEnabled ? S.of(context).RideListNoAttendees :  S.of(context).RideListNoMembers,softWrap: true),
          ],
        ),
      ),
    );
  }
}