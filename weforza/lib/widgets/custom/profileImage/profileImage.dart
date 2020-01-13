import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///This [Widget] displays a round profile icon or a placeholder if no image is present.
class ProfileImage extends StatelessWidget {
  ProfileImage(this._image,this._placeholderIconColor,this._placeholderBackgroundColor,[this._icon = Icons.person,this._size = 75]):
        assert(_placeholderIconColor != null && _placeholderBackgroundColor != null && _size != null);

  ///The image to show.
  final File _image;
  ///The icon to use as placeholder
  final IconData _icon;
  ///The width and height of the displayed [Image].
  final double _size;
  ///The background color for the placeholder icon's background.
  final Color _placeholderBackgroundColor;
  ///The icon color for the placeholder icon.
  final Color _placeholderIconColor;

  @override
  Widget build(BuildContext context) {
    return (_image == null) ? Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _placeholderBackgroundColor
      ),
      child: Center(
        child: Icon(_icon,color: _placeholderIconColor,size: .8*_size),
      ),
    ) : ClipOval(child: Image.file(_image,width: _size,height: _size,fit: BoxFit.cover));
  }
}