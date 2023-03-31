import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberNameAndAlias.dart';
import 'package:weforza/widgets/custom/profileImage/asyncProfileImage.dart';

/// This class is used as the type parameter of [ManualSelectionListItem]'s key.
class ManualSelectionListItemKey {
  ManualSelectionListItemKey({
    required this.firstName,
    required this.lastName,
    required this.alias,
  });

  final String firstName;
  final String lastName;
  final String alias;

  @override
  bool operator ==(Object other) {
    return other is ManualSelectionListItemKey
        && firstName == other.firstName
        && lastName == other.lastName
        && alias == other.alias;
  }

  @override
  int get hashCode => hashValues(firstName, lastName, alias);
}

class ManualSelectionListItem extends StatefulWidget {
  ManualSelectionListItem({
    required this.isSelected,
    required this.onTap,
    required this.profileImageFuture,
    required this.firstName,
    required this.lastName,
    required this.alias,
    required this.personInitials,
  }): super(
    key: ValueKey<ManualSelectionListItemKey>(
      ManualSelectionListItemKey(
        firstName: firstName,
        lastName: lastName,
        alias: alias,
      ),
    ),
  );

  final bool Function() isSelected;
  final VoidCallback onTap;
  final Future<File?> profileImageFuture;
  final String firstName;
  final String lastName;
  final String alias;
  final String personInitials;

  @override
  _ManualSelectionListItemState createState() => _ManualSelectionListItemState();
}

class _ManualSelectionListItemState extends State<ManualSelectionListItem> {

  late Color itemDecorationBackgroundColor;
  late TextStyle firstNameStyle;
  late TextStyle lastNameStyle;

  @override
  void initState() {
    super.initState();
    _setColors();
  }

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                  child: MemberNameAndAlias(
                    firstNameStyle: firstNameStyle,
                    lastNameStyle: lastNameStyle,
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    alias: widget.alias,
                  )
              ),
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
    }else{
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.memberListItemFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.memberListItemLastNameTextStyle;
    }
  }
}
