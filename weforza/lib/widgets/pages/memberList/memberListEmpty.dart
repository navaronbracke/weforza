
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';

///This [Widget] represents content for an empty [MemberListPage].
class MemberListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(S.of(context).MemberListNoItems),
          SizedBox(height: 5),
          Text(S.of(context).MemberListAddMemberInstruction)
        ],
      ),
    );
  }
}