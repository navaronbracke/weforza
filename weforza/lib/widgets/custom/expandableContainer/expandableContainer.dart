
import 'package:flutter/widgets.dart';

class ExpandableContainer extends StatelessWidget {
  ExpandableContainer({
    @required this.child,
    @required this.animation,
  }): assert(
    child != null && animation != null
  );

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
        ),
        child: child
    );
  }
}