import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a list item for [MemberListPage].
class MemberListItem extends StatelessWidget implements PlatformAwareWidget {
  MemberListItem(this._member,this._callback): assert(_member != null && _callback != null);

  ///The member for this item.
  final Member _member;
  ///A callback that is fired when the members should reload.
  final Function(bool reload) _callback;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.build(context, this);


  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
              Text(_member.firstname,style: ApplicationTheme.memberListItemFirstNameTextStyle, overflow: TextOverflow.ellipsis),
              SizedBox(height: 5),
              Text(_member.lastname, style: ApplicationTheme.memberListItemLastNameTextStyle, overflow: TextOverflow.ellipsis),
        ],
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage(_member))).then((value) => _callback(value));
      },
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage(_member))).then((value) => _callback(value));
      },
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_member.firstname,
                  style: ApplicationTheme.memberListItemFirstNameTextStyle,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: 4),
              Text(_member.lastname,
                  style: ApplicationTheme.memberListItemLastNameTextStyle,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}
