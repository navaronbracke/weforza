import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/memberItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';


///This [StatelessWidget] wraps a [MemberItem] in a display widget.
///It displays a profile picture, a first name and a last name.
///It also takes an optional on tap callback.
class MemberWithPictureListItem extends StatelessWidget {
  MemberWithPictureListItem({@required this.item, this.onTap}): assert(item != null);

  final MemberItem item;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return (onTap == null) ? _buildWithoutGestureDetector()
        : _buildWithGestureDetector();
  }

  Widget _buildWithGestureDetector(){
    return GestureDetector(
      onTap: onTap,
      child: _buildWithoutGestureDetector(),
    );
  }

  Widget _buildWithoutGestureDetector(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          ProfileImage(
            image: item.profileImage,
            icon: Icons.person,
            size: 40,
            personInitials: item.firstName[0] + item.lastName[0],
          ),
          SizedBox(width: 5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.firstName,
                      style: ApplicationTheme.memberListItemFirstNameTextStyle,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 4),
                  Text(item.lastName,
                      style: ApplicationTheme.memberListItemLastNameTextStyle,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
