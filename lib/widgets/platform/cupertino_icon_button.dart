import 'package:flutter/cupertino.dart';

/// This widget represents a [CupertinoButton] that displays an [Icon] as child.
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    super.key,
    this.color = CupertinoColors.activeBlue,
    required this.icon,
    required this.onPressed,
    this.size = kMinInteractiveDimensionCupertino,
  }) : assert(size >= kMinInteractiveDimensionCupertino);

  /// The color for the icon.
  ///
  /// Defaults to [CupertinoColors.activeBlue].
  final Color color;

  /// The icon for the button.
  final IconData icon;

  /// The onTap handler for the button.
  final void Function() onPressed;

  /// The size for the button.
  final double size;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      borderRadius: BorderRadius.zero,
      minSize: size,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Icon(icon, color: color),
    );
  }
}
