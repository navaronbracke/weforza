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
    @required this.selectImage,
    @required this.clear,
    @required this.image,
    this.personInitials
  }): assert(
    size != null && size > 0 && errorMessage != null && isSelecting != null
        && selectImage != null && clear != null && personInitials == null || personInitials.isNotEmpty
  );

  ///The size for a selected image.
  final double size;
  ///An error message to display when the image couldn't be loaded.
  final String errorMessage;
  ///This function is called when the selected image should be cleared.
  final void Function() clear;
  ///This function is called when an image selection is requested.
  final void Function() selectImage;

  final Stream<bool> isSelecting;

  final File image;

  final String personInitials;

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
                size: size,
                image: image,
                personInitials: personInitials,
              ),
              onTap: selectImage,
              onLongPress: clear,
          );
        }
      },
    );
  }
}