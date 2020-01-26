import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';

///This class represents an error [Widget] for [MemberListPage].
class MemberListError extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Center(child: Text(S.of(context).MemberListLoadingFailed));
}