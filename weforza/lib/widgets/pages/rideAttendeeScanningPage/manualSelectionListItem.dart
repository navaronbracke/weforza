import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class ManualSelectionListItem extends StatefulWidget {
  ManualSelectionListItem({
    @required this.isSelected,
    @required this.canSelect,
    @required this.onTap,
    @required this.profileImageFuture,
    @required this.firstName,
    @required this.lastName,
  }): assert(
    isSelected != null && canSelect != null && profileImageFuture != null &&
        onTap != null && firstName != null && lastName != null
  );

  final bool Function() isSelected;
  final bool Function() canSelect;
  final VoidCallback onTap;
  final Future<File> profileImageFuture;
  final String firstName;
  final String lastName;

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
        if(mounted && widget.canSelect()){
          widget.onTap();
          setState(() => _setColors());
        }
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            _getProfileImage(),
            SizedBox(width: 5),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: itemDecorationBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.firstName,
                      style: firstNameStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.lastName,
                      style: lastNameStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  void _setColors(){
    if(widget.isSelected()){
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.rideAttendeeSelectedFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.rideAttendeeSelectedLastNameTextStyle;
    }else{
      itemDecorationBackgroundColor = ApplicationTheme.rideAttendeeUnSelectedBackgroundColor;
      firstNameStyle = ApplicationTheme.rideAttendeeUnselectedFirstNameTextStyle;
      lastNameStyle = ApplicationTheme.rideAttendeeUnselectedLastNameTextStyle;
    }
  }

  Widget _getProfileImage(){
    return FutureBuilder<File>(
      future: widget.profileImageFuture,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return ProfileImage(
                image: null,//fallback to placeholder if file cannot be opened
                icon: Icons.person,
                size: 40
            );
          }else{
            return ProfileImage(
                image: snapshot.data,
                icon: Icons.person,
                size: 40
            );
          }
        }else{
          return SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          );
        }
      },
    );
  }
}
