
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

class MemberListEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.people,
            color: ApplicationTheme.listInformationalIconColor,
            size: MediaQuery.of(context).size.shortestSide * .1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(S.of(context).MemberListNoItems),
          ),
          Text(S.of(context).MemberListAddMemberInstruction)
        ],
      ),
    );
  }
}