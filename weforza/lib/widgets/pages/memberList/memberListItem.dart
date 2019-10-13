import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/blocs/memberSelectBloc.dart';
import 'package:weforza/generated/i18n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This class represents a list item for [MemberListPage].
class MemberListItem extends StatelessWidget implements PlatformAwareWidget {
  MemberListItem(this._member, this._selectBloc)
      : assert(_member != null && _selectBloc != null);

  ///The member for this item.
  final Member _member;

  ///The BLoC that handles the selection.
  final MemberSelectBloc _selectBloc;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  ///Layout
  ///
  ///First name, last name and phone are on the left.
  ///A details button is on the right.
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_member.firstname,style: ApplicationTheme.memberListItemFirstNameTextStyle,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 5),
          Text(_member.lastname, style: ApplicationTheme.memberListItemLastNameTextStyle,
              overflow: TextOverflow.ellipsis),
          SizedBox(height: 5),
          Text(
              S.of(context).MemberPhoneFormat(_member.phone),
              style: ApplicationTheme.memberListItemLastNameTextStyle,
              overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: SizedBox(
          width: 40,
          child: IconButton(
            icon: Icon(Icons.contacts, color: Theme.of(context).primaryColor),
            splashColor: ApplicationTheme.goToMemberDetailSplashColor,
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage())),
          ),
        ),
    );
  }

  ///Layout
  ///
  ///First name, last name and phone are on the left.
  ///A details button is on the right.
  @override
  Widget buildIosWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
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
                SizedBox(height: 10),
                Text(
                    S.of(context).MemberPhoneFormat(_member.phone),
                    style: ApplicationTheme.memberListItemLastNameTextStyle,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: GestureDetector(
              child: Icon(
                Icons.contacts,
                color: CupertinoTheme.of(context).primaryColor,
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage())),
            ),
          ),
        ],
      ),
    );
  }
}
