
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

///This class represents a [Widget] for selecting a profile picture.
class ProfileImagePicker extends StatefulWidget {
  ProfileImagePicker(this.onPressed,this.idleColor,this.onPressedColor) : assert(onPressed != null && idleColor != null && onPressedColor != null);

  ///A [VoidCallback] for when this [Widget] is tapped.
  final VoidCallback onPressed;
  ///The background color when the [Widget] is idle.
  final Color idleColor;//accent/primary constrasting
  ///The background color when the [Widget] is being pressed.
  final Color onPressedColor;//primary


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
    return RawMaterialButton(
      onPressed: () {
        widget.onPressed();
      },
      child: Icon(Icons.camera_alt,
          color: Colors.white, size: 50),
      shape: CircleBorder(),
      splashColor: widget.onPressedColor,
      elevation: 2.0,
      fillColor: widget.idleColor,
      padding: const EdgeInsets.all(15.0),
    );
  }

  @override
  Widget buildIosWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: _currentColor),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Icon(Icons.camera_alt,
              color: Colors.white, size: 50),
        ),
      ),
      onTap: () {
        widget.onPressed();
      },
      onTapUp: (tapUpDetails){
        setState(() {
          _currentColor = widget.idleColor;
        });
      },
      onTapDown: (tapUpDetails){
        setState(() {
          _currentColor = widget.onPressedColor;
        });
      },
    );
  }

}