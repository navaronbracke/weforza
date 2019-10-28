

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] displays a round profile icon.
class ProfileImage extends StatelessWidget {
  ProfileImage(this._image,[this._size = 75]): assert(_size != null);

  ///The image to show.
  final File _image;

  ///The width and height of the displayed [Image].
  final double _size;

  @override
  Widget build(BuildContext context) {
    return (_image == null) ? _ProfileImagePlaceholder(_size) : ClipOval(
      child: Image.file(_image,width: _size,height: _size,fit: BoxFit.cover),
    );
  }

}

class _ProfileImagePlaceholder extends StatelessWidget implements PlatformAwareWidget {
  _ProfileImagePlaceholder(this._size): assert(_size != null);

  final double _size;

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Container(
      height: _size,
      width: _size,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor
      ),
      child: Center(
        child: Icon(Icons.person,color: Colors.white,size: .8*_size),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Container(
        height: _size,
        width: _size,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoTheme.of(context).primaryContrastingColor),
        child: Center(
          child: Icon(Icons.person,color: Colors.white,size: .8*_size),
        ),
    );
  }

}