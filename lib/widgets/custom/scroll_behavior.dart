import 'package:flutter/cupertino.dart';

/// This class represents a [ScrollBehavior] that does not apply an overscroll indicator to its child.
class NoOverscrollIndicatorScrollBehavior extends ScrollBehavior {
  const NoOverscrollIndicatorScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
