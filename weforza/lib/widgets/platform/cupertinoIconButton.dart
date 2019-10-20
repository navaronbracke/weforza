import 'package:flutter/widgets.dart';

///This [Widget] represents a custom ios icon button.
class CupertinoIconButton extends StatefulWidget {
  CupertinoIconButton(this.icon,this.idleColor,this.onPressedColor,this.onPressed): assert(icon != null && onPressed != null && idleColor != null && onPressedColor != null);

  final VoidCallback onPressed;

  final IconData icon;

  final Color idleColor;

  final onPressedColor;

  @override
  _CupertinoIconButtonState createState() => _CupertinoIconButtonState();
}

class _CupertinoIconButtonState extends State<CupertinoIconButton> {

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