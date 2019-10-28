

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImageProvider.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This [Widget] displays a round profile icon.
class ProfileImage extends StatelessWidget {
  ProfileImage(this._provider,[this._size = 75]): assert(_size != null && _provider != null);

  ///The image provider.
  final IProfileImageProvider _provider;

  ///The width and height of the displayed [Image].
  final double _size;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _provider.imageExists(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError || (snapshot.data == false)){
            return _ProfileImagePlaceholder();
          }else{
            return ClipOval(
              child: Image.file(_provider.image,width: _size,height: _size,fit: BoxFit.cover),
            );
          }
        }else{
          return _ProfileImagePlaceholder();
        }
      },
    );
  }

}

class _ProfileImagePlaceholder extends StatelessWidget implements PlatformAwareWidget {

  @override
  Widget build(BuildContext context) => PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).accentColor
      ),
      child: Center(
        child: Icon(Icons.person,color: Colors.white,size: 50),
      ),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CupertinoTheme.of(context).primaryContrastingColor),
        child: Center(
          child: Icon(Icons.person,color: Colors.white,size: 50),
        ),
    );
  }

}