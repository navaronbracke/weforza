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
    this.icon = Icons.person,
    this.iconColor = ApplicationTheme.profileImagePlaceholderIconColor,
    this.backgroundColor = ApplicationTheme.profileImagePlaceholderIconBackgroundColor,
  }): assert(iconColor != null && backgroundColor != null && size != null);

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

  @override
  Widget build(BuildContext context) {
    return (image == null) ? Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor
      ),
      child: Center(
        child: Icon(icon,color: iconColor,size: .7*size),
      ),
    ) : ClipOval(child: Image.file(image,width: size,height: size,fit: BoxFit.cover));
  }
}