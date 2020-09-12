import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/loadableProfileImage.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';

class ManualSelectionListItem extends StatefulWidget {
  ManualSelectionListItem({
    @required this.isSelected,
    @required this.onTap,
    @required this.profileImageFuture,
    @required this.firstName,
    @required this.lastName,
    @required this.alias
  }): assert(
    isSelected != null && profileImageFuture != null &&
        onTap != null && firstName != null && lastName != null && alias != null
  );

  final bool Function() isSelected;
  final VoidCallback onTap;
  final Future<File> profileImageFuture;
  final String firstName;
  final String lastName;
  final String alias;

  @override
  _ManualSelectionListItemState createState() => _ManualSelectionListItemState();
}

class _ManualSelectionListItemState extends State<ManualSelectionListItem> {

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
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: LoadableProfileImage(
                  image: widget.profileImageFuture,
                  size: 40,
                  onDone: (size, image){
                    return ProfileImage(
                      image: image,
                      icon: Icons.person,
                      size: size,
                      personInitials: widget.firstName[0] + widget.lastName[0],
                    );
                  },
                  onError: (size){
                    return ProfileImage(
                      icon: Icons.person,
                      size: size,
                      personInitials: widget.firstName[0] + widget.lastName[0],
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _combineFirstNameAndAlias(),
                    SizedBox(height: 5),
                    Text(
                      widget.lastName,
                      style: lastNameStyle,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
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

    // Firstname 'alias' Lastname
    return RichText(
      text: TextSpan(
        text: widget.firstName,
        style: firstNameStyle,
        children: [
          TextSpan(
            text: " ${widget.alias} ",
            style: firstNameStyle.copyWith(fontStyle: FontStyle.italic),
          ),
          TextSpan(
            text: widget.lastName,
            style: firstNameStyle,
          ),
        ]
      ),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }
}
