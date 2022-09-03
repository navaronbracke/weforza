import 'package:flutter/cupertino.dart';

/// A Cupertino equivalent of the Material [BottomAppBar]
/// with theming similar to a [CupertinoTabBar].
class CupertinoBottomBar extends StatelessWidget {
  /// The default constructor.
  const CupertinoBottomBar({super.key, required this.child, this.height});

  /// Create a [CupertinoBottomBar] with a height
  /// equal to that of a [CupertinoTabBar].
  const CupertinoBottomBar.constrained({
    Key? key,
    required Widget child,
  }) : this(key: key, child: child, height: _kTabBarHeight);

  /// The child for this widget.
  final Widget child;

  /// The height that this widget should occupy.
  /// If this is null, this widget sizes itself to fit its [child].
  final double? height;

  /// The height of a [CupertinoTabBar] in iOS 10.
  static const _kTabBarHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;

    const border = Border(
      top: BorderSide(
        // Color resolution is the same as in CupertinoTabBar.
        color: CupertinoDynamicColor.withBrightness(
          color: Color(0x4C000000),
          darkColor: Color(0x29000000),
        ),
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    );

    // The content gets a DefaultTextStyle to match the iOS text styles.
    // It also gets bottom padding to avoid the bottom notch.
    Widget content = DefaultTextStyle(
      style: CupertinoTheme.of(context).textTheme.textStyle,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: child,
      ),
    );

    if (height != null) {
      content = SizedBox(height: height! + bottomPadding, child: content);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: border.top.copyWith(
            color: CupertinoDynamicColor.resolve(border.top.color, context),
          ),
        ),
        color: backgroundColor,
      ),
      child: content,
    );
  }
}
