import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/platform/loadingIndicator.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';

///This class represents a loading [Widget] for [MemberListPage].
class MemberListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          PlatformAwareLoadingIndicator(),
          SizedBox(height: 5),
          Text(S.of(context).MemberListLoadingInProgress),
        ],
      ),
    );
  }
}