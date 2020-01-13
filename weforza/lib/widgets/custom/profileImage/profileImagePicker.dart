
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker(this.onPressedHandler,this.image,this.placeholderIconColor,this.placeholderBackgroundColor,this._size)
      : assert(onPressedHandler != null && placeholderIconColor != null && placeholderBackgroundColor != null && _size != null);

  ///A [VoidCallback] for when this [Widget] is tapped.
  final IProfileImagePicker onPressedHandler;
  ///The selected image. When a new image is selected, this widget's parent is rebuilt.
  final File image;

  final Color placeholderIconColor;
  final Color placeholderBackgroundColor;

  final double _size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ProfileImage(image,placeholderIconColor,placeholderBackgroundColor,Icons.camera_alt,_size),
        onTap: () => onPressedHandler.pickProfileImage()
    );
  }

}