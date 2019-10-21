
import 'dart:io';

import 'package:flutter/widgets.dart';

///This [Widget] displays a round profile icon.
class ProfileImage extends StatelessWidget {
  ProfileImage(this._image,[this._size = 75]);

  ///The image to display.
  final File _image;

  ///The width and height of the displayed [Image].
  final double _size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.file(_image,width: _size,height: _size,fit: BoxFit.cover),
    );
  }

}