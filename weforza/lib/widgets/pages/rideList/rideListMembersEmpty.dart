
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';

///This class represents an empty list [Widget] for the 'Members' section of [RideListPage].
class RideListMembersEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).RideListNoMembers),
          SizedBox(height: 5),
          Text(S.of(context).RideListAddMemberInstruction),
        ],
      ),
    );
  }
}