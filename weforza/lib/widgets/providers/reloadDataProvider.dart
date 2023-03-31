import 'package:flutter/widgets.dart';

///This InheritedWidget manages reload flags for Ride and Member.
class ReloadDataProvider extends InheritedWidget {
  ReloadDataProvider({
    Key key,
    @required Widget child,
  }) : assert(child != null), super(key: key, child: child);

  final ValueNotifier<bool> reloadRides = ValueNotifier(true);
  final ValueNotifier<bool> reloadMembers = ValueNotifier(true);
  final ValueNotifier<bool> reloadDevices = ValueNotifier(true);

  static ReloadDataProvider of(BuildContext context)
    => context.dependOnInheritedWidgetOfExactType<ReloadDataProvider>();

  @override
  bool updateShouldNotify(ReloadDataProvider old)
   => reloadRides != old.reloadRides
       && reloadMembers != old.reloadMembers
       && reloadDevices != old.reloadDevices;
}