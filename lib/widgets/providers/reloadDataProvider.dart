import 'package:flutter/widgets.dart';

///This InheritedWidget manages reload flags for Ride and Member.
class ReloadDataProvider extends InheritedWidget {
  ReloadDataProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final ValueNotifier<bool> reloadRides = ValueNotifier(true);
  final ValueNotifier<bool> reloadMembers = ValueNotifier(true);
  final ValueNotifier<bool> reloadDevices = ValueNotifier(true);

  static ReloadDataProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ReloadDataProvider>();

    assert(
        provider != null, 'There is no ReloadDataProvider in the Widget tree.');

    return provider!;
  }

  @override
  bool updateShouldNotify(ReloadDataProvider oldWidget) =>
      reloadRides != oldWidget.reloadRides &&
      reloadMembers != oldWidget.reloadMembers &&
      reloadDevices != oldWidget.reloadDevices;
}
