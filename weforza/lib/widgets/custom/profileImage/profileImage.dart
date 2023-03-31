import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] displays a round profile icon or a placeholder if no image is present.
class ProfileImage extends StatelessWidget {
  ProfileImage({
    this.image,
    this.size = 75,
    @required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.personInitials,
  }): assert(
    icon != null && iconColor != null &&
        backgroundColor != null && size != null && size > 0
  );

  ///The image to show.
  final File image;
  ///The icon to use as placeholder
  final IconData icon;
  ///The width and height of the displayed [Image].
  final double size;
  ///The background color for the placeholder icon's background.
  final Color backgroundColor;
  ///The icon color for the placeholder icon.
  final Color iconColor;

  final String personInitials;

  Color _getBackgroundColor(){
    int index = personInitials.codeUnitAt(0);
    if(personInitials.length == 2){
      index += personInitials.codeUnitAt(1);
    }

    return Colors.primaries[index % Colors.primaries.length];
  }

  @override
  Widget build(BuildContext context) {
    if(image == null){
      if(personInitials == null || personInitials.isEmpty){
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor
          ),
          child: Center(
            child: Icon(
              icon,
              color: iconColor,
              size: .7 * size,
            ),
          ),
        );
      }else{
        return Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getBackgroundColor(),
          ),
          child: Center(
            child: Text(
                personInitials.toUpperCase(),
                style: ApplicationTheme.personInitialsTextStyle.copyWith(
                    fontSize: .5 * size
                ),
            ),
          ),
        );
      }
    }
    return ClipOval(
        child: Image.file(
            image,
            width: size,
            height: size,
            fit: BoxFit.cover,
        ),
    );
  }
}