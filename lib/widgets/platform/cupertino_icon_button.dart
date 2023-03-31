import 'package:flutter/widgets.dart';
import 'package:weforza/theme/app_theme.dart';

/// This widget represents an iOS variant of the Material `IconButton`.
class CupertinoIconButton extends StatefulWidget {
  const CupertinoIconButton({
    super.key,
    required this.icon,
    this.idleColor = ApplicationTheme.primaryColor,
    required this.onPressed,
    this.onPressedColor = ApplicationTheme.secondaryColor,
    this.size = 28,
  });

  /// The icon for the button.
  final IconData icon;

  /// The color for the icon when it is not pressed.
  ///
  /// Defaults to [ApplicationTheme.primaryColor].
  final Color idleColor;

  /// The onTap handler for the button.
  final void Function() onPressed;

  /// The color for the icon when it is pressed.
  ///
  /// Defaults to [ApplicationTheme.secondaryColor].
  final Color onPressedColor;

  /// The size for the button.
  ///
  /// Defaults to 28.
  final double size;

  @override
  State<CupertinoIconButton> createState() => _CupertinoIconButtonState();
}

class _CupertinoIconButtonState extends State<CupertinoIconButton> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.idleColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapUp: (tapUpDetails) {
        setState(() {
          color = widget.idleColor;
        });
      },
      onTapDown: (tapUpDetails) {
        setState(() {
          color = widget.onPressedColor;
        });
      },
      child: Icon(widget.icon, color: color, size: widget.size),
    );
  }
}
