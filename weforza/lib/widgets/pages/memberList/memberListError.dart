import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';

///This class represents an error [Widget] for [MemberListPage].
class MemberListError extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.warning,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          SizedBox(height: 5),
          Text(S.of(context).MemberListLoadingFailed)
        ],
      ),
    );
  }
}