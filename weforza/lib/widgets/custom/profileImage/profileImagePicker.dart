
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker(this.onPressedHandler,this.image,this._size)
      : assert(onPressedHandler != null && _size != null);

  ///A [VoidCallback] for when this [Widget] is tapped.
  final IProfileImagePicker onPressedHandler;
  ///The selected image. When a new image is selected, this widget's parent is rebuilt.
  final File image;

  final double _size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: ProfileImage(
            image: image,
            size: _size,
            icon: Icons.camera_alt,
        ),
        onTap: () => onPressedHandler.pickProfileImage()
    );
  }
}