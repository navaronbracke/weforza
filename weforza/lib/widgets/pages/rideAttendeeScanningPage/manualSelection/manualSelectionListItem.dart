import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberNameAndAlias.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';

class ManualSelectionListItem extends StatefulWidget {
  ManualSelectionListItem({
    @required this.isActiveMember,
    @required this.isSelected,
    @required this.onTap,
    @required this.profileImageFuture,
    @required this.firstName,
    @required this.lastName,
    @required this.alias,
    @required this.personInitials,
  }): assert(
    isSelected != null && profileImageFuture != null && personInitials != null
        && personInitials.isNotEmpty && onTap != null && firstName != null
        && lastName != null && alias != null && isActiveMember != null
  );

  final bool isActiveMember;
  final bool Function() isSelected;
  final VoidCallback onTap;
  final Future<File> profileImageFuture;
  final String firstName;
  final String lastName;
  final String alias;
  final String personInitials;

  @override
  _ManualSelectionListItemState createState() => _ManualSelectionListItemState();
}

class _ManualSelectionListItemState extends State<ManualSelectionListItem> {

  Color itemDecorationBackgroundColor;
  TextStyle firstNameStyle;
  TextStyle lastNameStyle;
  TextStyle inactiveLabelStyle;

  @override
  void initState() {
    super.initState();
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
    final Widget content = widget.isActiveMember ? MemberNameAndAlias(
      firstNameStyle: firstNameStyle,
      lastNameStyle: lastNameStyle,
      firstName: widget.firstName,
      lastName: widget.lastName,
      alias: widget.alias,
    ): Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: MemberNameAndAlias(
            firstNameStyle: firstNameStyle,
            lastNameStyle: lastNameStyle,
            firstName: widget.firstName,
            lastName: widget.lastName,
            alias: widget.alias,
          ),
        ),
        Text(S.of(context).Inactive.toUpperCase(), style: inactiveLabelStyle),
      ],
    );

    return GestureDetector(
      onTap: (){
        if(mounted){
          widget.onTap();
          setState(() => _setColors());
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: itemDecorationBackgroundColor
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: AsyncProfileImage(
                  icon: Icons.person,
                  future: widget.profileImageFuture,
                  personInitials: widget.personInitials,
                ),
              ),
              Expanded(child: content),
            ],
          ),
        ),
      ),
    );
  }

  void _setColors(){
    if(widget.isSelected()){
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle.copyWith(color: Colors.white);
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle.copyWith(color: Colors.white);
      inactiveLabelStyle = ApplicationTheme.rideAttendeeManualSelectionSelectedInactiveLabelStyle;
    }else{
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle;
      inactiveLabelStyle = ApplicationTheme.rideAttendeeManualSelectionUnselectedInactiveLabelStyle;
    }
  }
}
