import 'package:flutter/cupertino.dart';

/// A Cupertino equivalent of the Material [BottomAppBar].
/// Styles have been adapted from [CupertinoTabBar].
class CupertinoBottomBar extends StatelessWidget {
  CupertinoBottomBar({ required this.child });

  final Widget child;

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

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: resolveBorderSide(context, border.top)),
        color: backgroundColor,
      ),
      child: SizedBox(
        // We create a SizedBox that takes up the combined bar + notch height.
        // Then we push the child upwards, using the notch height.
        height: _kTabBarHeight + bottomPadding,
        child: DefaultTextStyle(
          style: CupertinoTheme.of(context).textTheme.textStyle,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}