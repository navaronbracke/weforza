
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platformAwareWidgetBuilder.dart';

///This [Widget] represents a [Member] within the 'Attendees' content panel of [RideListPage].
class MemberItem extends StatelessWidget implements PlatformAwareWidget {
  MemberItem(this._member): assert(_member != null);
  ///The [Member] of this item.
  final Member _member;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.buildPlatformAwareWidget(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      onTap: (){
        //TODO: add/remove from selected ride if possible
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(_member.firstname,style: ApplicationTheme.memberListItemFirstNameTextStyle,overflow: TextOverflow.ellipsis),
          SizedBox(height: 5),
          Text(_member.lastname,style: ApplicationTheme.memberListItemLastNameTextStyle,overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    // TODO: implement buildIosWidget
    return null;
  }
}