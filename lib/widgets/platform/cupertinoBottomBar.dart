import 'package:flutter/cupertino.dart';

/// A Cupertino equivalent of the Material [BottomAppBar].
/// Styles have been adapted from [CupertinoTabBar].
class CupertinoBottomBar extends StatelessWidget {
  const CupertinoBottomBar._({
    required this.child,
    required this.useMaximumTabBarHeight,
  });

  /// Constructor for [CupertinoBottomBar]'s that act like a [CupertinoTabBar].
  const CupertinoBottomBar.tabBar({
    required Widget child
  }): this._(child: child, useMaximumTabBarHeight: true);

  /// Constructor for [CupertinoBottomBar]'s
  /// that let their child decide the height.
  const CupertinoBottomBar({
    required Widget child
  }) : this._(child: child, useMaximumTabBarHeight: false);

  final Widget child;

  /// Whether to limit the height of the [child]
  /// to a maximum of [_kTabBarHeight].
  final bool useMaximumTabBarHeight;

  /// Standard iOS 10 tab bar height.
  /// Taken from [CupertinoTabBar].
  final double _kTabBarHeight = 50.0;

  /// BorderSide resolution, as defined in [CupertinoTabBar].
  BorderSide resolveBorderSide(BuildContext context,  BorderSide side){
    return side.copyWith(color: CupertinoDynamicColor.resolve(side.color, context));
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;

    final Border border = Border(
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

    if(useMaximumTabBarHeight){
      content = SizedBox(
        // We create a SizedBox that takes up
        // the maximum tab bar height + notch height.
        //
        // Since the child gets some padding that is equal to the notch height,
        // it gets pushed upwards into the upper part of the SizedBox,
        // away from the notch.
        height: _kTabBarHeight + bottomPadding,
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: resolveBorderSide(context, border.top)),
        color: backgroundColor,
      ),
      child: content,
    );
  }
}