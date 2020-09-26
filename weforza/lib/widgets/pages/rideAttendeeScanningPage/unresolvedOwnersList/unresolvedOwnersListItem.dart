import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: _combineFirstNameAndAlias(),
              ),
              Text(
                widget.lastName,
                style: lastNameStyle,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _setColors(){
    if(widget.isSelected()){
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.rideAttendeeFirstNameTextStyle.copyWith(color: Colors.white);
      lastNameStyle = ApplicationTheme.rideAttendeeLastNameTextStyle.copyWith(color: Colors.white);
    }else{
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.rideAttendeeFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.rideAttendeeLastNameTextStyle;
    }
  }

  //Combine the first name with the alias.
  Widget _combineFirstNameAndAlias(){
    if(widget.alias.isEmpty){
      return Text(
        widget.firstName,
        style: firstNameStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Firstname 'alias'
    return Text.rich(
      TextSpan(
          text: widget.firstName,
          style: firstNameStyle,
          children: [
            TextSpan(
              text: " " + widget.alias,
              style: firstNameStyle.copyWith(fontStyle: FontStyle.italic),
            ),
          ]
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

