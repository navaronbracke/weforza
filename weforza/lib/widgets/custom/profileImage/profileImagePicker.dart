import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatelessWidget {
  ProfileImagePicker({
    @required this.errorMessage,
    @required this.size,
    @required this.isSelecting,
    @required this.getImage,
    @required this.selectImage,
    @required this.clear
  }): assert(
    size != null && errorMessage != null && isSelecting != null 
        && getImage != null && selectImage != null && clear != null
  );

  ///The size for a selected image.
  final double size;
  ///An error message to display when the image couldn't be loaded.
  final String errorMessage;

  final void Function() clear;

  final void Function() selectImage;

  final File Function() getImage;

  final Stream<bool> isSelecting;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSelecting,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Center(child: Text(errorMessage,softWrap: true));
        }else{
          return snapshot.data ? SizedBox(
            width: size,
            height: size,
            child: Center(
              child: PlatformAwareLoadingIndicator(),
            ),
          ): GestureDetector(
              child: ProfileImage(
                image: getImage(),
                size: size,
                icon: Icons.camera_alt,
              ),
              onTap: selectImage,
              onLongPress: clear,
          );
        }
      },
    );
  }
}