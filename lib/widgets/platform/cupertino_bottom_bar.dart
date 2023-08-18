import 'package:flutter/cupertino.dart';

/// A Cupertino equivalent of the Material [BottomAppBar]
/// with theming similar to a [CupertinoTabBar].
class CupertinoBottomBar extends StatelessWidget {
  /// The default constructor.
  const CupertinoBottomBar({
    required this.child,
    super.key,
    this.height,
  });

  /// Create a [CupertinoBottomBar] with a height
  /// equal to that of a [CupertinoTabBar].
  const CupertinoBottomBar.constrained({
    required Widget child,
    Key? key,
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
    // As the keyboard pushes the CupertinoBottomBar up,
    // there is no need for applying the bottom padding of the notch.
    // Therefor, use the padding value instead of viewInsets, which decreases as the keyboard is shown.
    // The viewInsets on the otherhand, increases as the keyboard is shown.
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;

    const border = Border(
      top: BorderSide(
        // Color resolution is the same as in CupertinoTabBar.
        color: CupertinoDynamicColor.withBrightness(
          color: Color(0x4C000000),
          darkColor: Color(0x29000000),
        ),
        width: 0.0, // One physical pixel.
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
      child: Builder(
        builder: (context) => MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: content,
        ),
      ),
    );
  }
}
