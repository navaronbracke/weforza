
import 'package:flutter/widgets.dart';

class RideAttendeeScanStartTrigger extends InheritedWidget {
  RideAttendeeScanStartTrigger({
    Key key,
    @required Widget child,
  }) : assert(child != null), super(key: key, child: child);

  final ValueNotifier<bool> isStarted = ValueNotifier(false);

  static RideAttendeeScanStartTrigger of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RideAttendeeScanStartTrigger>();
  }

  @override
  bool updateShouldNotify(RideAttendeeScanStartTrigger old) => isStarted != old.isStarted;
}