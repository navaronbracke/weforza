import 'package:flutter/widgets.dart';

/// This widget represents a focus absorber.
///
/// It removes focus from the currently focused widget that is contained within
/// [child]'s subtree when it intercepts a tap event.
class FocusAbsorber extends StatelessWidget {
  const FocusAbsorber({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
