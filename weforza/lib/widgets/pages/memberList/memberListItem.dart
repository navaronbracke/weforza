import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/pages/memberDetails/memberDetailsPage.dart';
import 'package:weforza/widgets/pages/memberList/memberListPage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';
import 'package:weforza/widgets/provider/memberProvider.dart';

///This class represents a list item for [MemberListPage].
class MemberListItem extends StatelessWidget implements PlatformAwareWidget {
  MemberListItem(this._memberItem): assert(_memberItem != null);

  ///The member for this item.
  final MemberItem _memberItem;

  @override
  Widget build(BuildContext context) =>
      PlatformAwareWidgetBuilder.build(context, this);


  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
        leading: ProfileImage(_memberItem.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,Icons.person,40),
        title: Text(_memberItem.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle, overflow: TextOverflow.ellipsis),
        subtitle: Text(_memberItem.lastName, style: ApplicationTheme.memberListItemLastNameTextStyle, overflow: TextOverflow.ellipsis),
        onTap: (){
          Provider.of<MemberProvider>(context).selectedMember = _memberItem;
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage()));
        }
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Provider.of<MemberProvider>(context).selectedMember = _memberItem;
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MemberDetailsPage()));
        },
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              ProfileImage(_memberItem.profileImage,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,Icons.person,40),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_memberItem.firstName,
                      style: ApplicationTheme.memberListItemFirstNameTextStyle,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text(_memberItem.lastName,
                      style: ApplicationTheme.memberListItemLastNameTextStyle,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
