import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/common/memberNameAndAlias.dart';

class UnresolvedOwnersListItem extends StatefulWidget {
  UnresolvedOwnersListItem({
    @required this.isSelected,
    @required this.onTap,
    @required this.firstName,
    @required this.lastName,
    @required this.alias
  }): assert(
    isSelected != null && onTap != null && firstName != null
        && lastName != null && alias != null
  );

  final bool Function() isSelected;
  final VoidCallback onTap;
  final String firstName;
  final String lastName;
  final String alias;

  @override
  _UnresolvedOwnerListItemState createState() => _UnresolvedOwnerListItemState();
}

class _UnresolvedOwnerListItemState extends State<UnresolvedOwnersListItem> {

  Color itemDecorationBackgroundColor;
  TextStyle firstNameStyle;
  TextStyle lastNameStyle;

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
          child: MemberNameAndAlias(
            firstNameStyle: firstNameStyle,
            lastNameStyle: lastNameStyle,
            firstName: widget.firstName,
            lastName: widget.lastName,
            alias: widget.alias,
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

