import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] represents a custom ios icon button.
class CupertinoIconButton extends StatefulWidget {
  CupertinoIconButton({
  @required this.icon,
  @required this.onPressed,
  this.onPressedColor = ApplicationTheme.primaryColor,
  this.idleColor = ApplicationTheme.accentColor,
  }): assert(
    icon != null && onPressed != null
        && idleColor != null && onPressedColor != null
  );

  ///A [VoidCallback] that is invoked when this [Widget] is pressed.
  final VoidCallback onPressed;

  ///The icon to display.
  final IconData icon;

  ///The background color when not pressed.
  final Color idleColor;

  ///The background color when pressed.
  final Color onPressedColor;

  @override
  _CupertinoIconButtonState createState() => _CupertinoIconButtonState();
}

///This is the State class for [CupertinoIconButton].
class _CupertinoIconButtonState extends State<CupertinoIconButton> {

  ///The current background color.
  Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.idleColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: widget.onPressed,
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
      child: Icon(widget.icon,color: _currentColor),
    );
  }
}