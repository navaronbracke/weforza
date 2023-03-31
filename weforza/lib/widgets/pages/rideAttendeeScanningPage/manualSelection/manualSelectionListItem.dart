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
    @required this.phone
  }): assert(
    isSelected != null && profileImageFuture != null &&
        onTap != null && firstName != null && lastName != null && phone != null
  );

  final bool Function() isSelected;
  final VoidCallback onTap;
  final Future<File> profileImageFuture;
  final String firstName;
  final String lastName;
  final String phone;

  @override
  _ManualSelectionListItemState createState() => _ManualSelectionListItemState();
}

class _ManualSelectionListItemState extends State<ManualSelectionListItem> {

  Color itemDecorationBackgroundColor;
  TextStyle firstNameStyle;
  TextStyle lastNameStyle;
  TextStyle phoneTextStyle;
  Color phoneLabelIconColor;

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
                    Text(
                      widget.firstName,
                      style: firstNameStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            widget.lastName,
                            style: lastNameStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                size: 15,
                                color: phoneLabelIconColor,
                              ),
                              Text(" ${widget.phone}", style: phoneTextStyle),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      phoneTextStyle = ApplicationTheme.rideAttendeePhoneTextStyle.copyWith(color: Colors.white);
      phoneLabelIconColor = Colors.white;
    }else{
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.rideAttendeeFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.rideAttendeeLastNameTextStyle;
      phoneTextStyle = ApplicationTheme.rideAttendeePhoneTextStyle;
      phoneLabelIconColor = ApplicationTheme.rideAttendeeSelectedBackgroundColor;
    }
  }
}
