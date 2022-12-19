import 'package:flutter/cupertino.dart';

/// This widget represents a [CupertinoButton] that displays an [Icon] as child.
class CupertinoIconButton extends StatelessWidget {
  const CupertinoIconButton({
    super.key,
    this.color,
    required this.icon,
    required this.onPressed,
    this.size = kMinInteractiveDimensionCupertino,
  }) : assert(
          size >= kMinInteractiveDimensionCupertino,
          'The size of a CupertinoIconButton should be at least `kMinInteractiveDimensionCupertino`',
        );

  /// The color for the icon.
  ///
  /// Defaults to [CupertinoThemeData.primaryColor] if null.
  final Color? color;

  /// The icon for the button.
  final IconData icon;

  /// The onTap handler for the button.
  ///
  /// If this is null, the button is disabled.
  final void Function()? onPressed;

  /// The size for the button.
  final double size;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      borderRadius: BorderRadius.zero,
      minSize: size,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      child: Icon(
        icon,
        color: onPressed == null
            ? CupertinoColors.placeholderText
            : color ?? CupertinoTheme.of(context).primaryColor,
      ),
    );
  }
}
