
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/attendeeItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class RideAttendeeItem extends StatelessWidget implements PlatformAwareWidget {
  RideAttendeeItem(this.item): assert(item != null);

  final AttendeeItem item;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return ListTile(
      leading: ProfileImage(item.picture,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,Icons.person,40),
      title: Text(item.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle, overflow: TextOverflow.ellipsis),
      subtitle: Text(item.lastName, style: ApplicationTheme.memberListItemLastNameTextStyle, overflow: TextOverflow.ellipsis),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Center(
              child: ProfileImage(item.picture,ApplicationTheme.profileImagePlaceholderIconColor,ApplicationTheme.profileImagePlaceholderIconBackgroundColor,Icons.person,40),
            ),
          ),
          Flexible(
            flex: 9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(item.firstName,style: ApplicationTheme.memberListItemFirstNameTextStyle, overflow: TextOverflow.ellipsis),
                SizedBox(height: 5),
                Text(item.lastName, style: ApplicationTheme.memberListItemLastNameTextStyle, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
