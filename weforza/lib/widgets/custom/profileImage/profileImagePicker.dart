
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/custom/profileImage/iProfileImagePicker.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker(this.onPressedHandler,this.image,this.idleColor,this.onPressedColor) : assert(onPressedHandler != null && idleColor != null && onPressedColor != null);

  ///A [VoidCallback] for when this [Widget] is tapped.
  final IProfileImagePicker onPressedHandler;
  ///The background color when the [Widget] is idle.
  final Color idleColor;//accent/primary constrasting
  ///The background color when the [Widget] is being pressed.
  final Color onPressedColor;//primary

  final File image;


  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();

}

///This class is the [State] for [ProfileImagePicker].
class _ProfileImagePickerState extends State<ProfileImagePicker> implements PlatformAwareWidget {
  ///The current background color.
  ///Only used on IOS, since Material uses InkWell.
  Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.idleColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context)=> PlatformAwareWidgetBuilder.build(context, this);

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return (widget.image == null) ? RawMaterialButton(
      child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
      onPressed: () {
        widget.onPressedHandler.pickProfileImage();
      },
      shape: CircleBorder(),
      splashColor: widget.onPressedColor,
      elevation: 2.0,
      fillColor: widget.idleColor,
      padding: const EdgeInsets.all(15.0),
    ):
    GestureDetector(
      child: ProfileImage(widget.image),
      onTap: (){
        widget.onPressedHandler.pickProfileImage();
      }
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return (widget.image == null) ? GestureDetector(
      child: Container(
        decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: _currentColor),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
        ),
      ),
      onTap: () {
        widget.onPressedHandler.pickProfileImage();
      },
      onTapUp: (tapUpDetails){
        //Only trigger a redraw if there is no image.
        if(widget.image == null){
          setState(() {
            _currentColor = widget.idleColor;
          });
        }
      },
      onTapDown: (tapUpDetails){
        //Only trigger a redraw if there is no image.
        if(widget.image == null){
          setState(() {
            _currentColor = widget.onPressedColor;
          });
        }
      },
    ): GestureDetector(
        child: ProfileImage(widget.image),
        onTap: (){
          widget.onPressedHandler.pickProfileImage();
        }
    );
  }

}