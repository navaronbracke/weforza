import 'package:flutter/widgets.dart';
import 'package:weforza/model/memberItem.dart';

class RideAttendeeFutureProvider extends InheritedWidget {
  RideAttendeeFutureProvider({
    Key key,
    @required Widget child,
  }): assert(child != null), super(key: key, child: child);

  //This notifier holds the refreshed ride attendee future.
  //The initial load is managed by the RideDetailsPage bloc.
  //Subsequent refreshes are stored here.
  final ValueNotifier<Future<List<MemberItem>>> rideAttendeeFuture = ValueNotifier(null);

  static RideAttendeeFutureProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RideAttendeeFutureProvider>();
  }

  @override
  bool updateShouldNotify(RideAttendeeFutureProvider old) => rideAttendeeFuture != old.rideAttendeeFuture;
}