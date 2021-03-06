import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';

///This [Widget] represents a custom ios icon button.
class CupertinoIconButton extends StatefulWidget {
  CupertinoIconButton({
  required this.icon,
  required this.onPressed,
  required this.onPressedColor,
  required this.idleColor,
  this.size = 28,
  }): assert(size > 0);

  CupertinoIconButton.fromAppTheme({
    required VoidCallback onPressed,
    required IconData icon,
    double? size
  }): this(
    idleColor: ApplicationTheme.primaryColor,
    onPressedColor: ApplicationTheme.secondaryColor,
    icon: icon,
    onPressed: onPressed,
    size: size ?? 28
  );

  ///A [VoidCallback] that is invoked when this [Widget] is pressed.
  final VoidCallback onPressed;

  ///The icon to display.
  final IconData icon;

  final double size;

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
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.idleColor;
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
      child: Icon(
        widget.icon,
        color: _currentColor,
        size: widget.size,
      ),
    );
  }
}