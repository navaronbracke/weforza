import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';

class RideAttendeeFutureProvider extends InheritedWidget {
  RideAttendeeFutureProvider({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  //This notifier holds the refreshed ride attendee future.
  //The initial load is managed by the RideDetailsPage bloc.
  //Subsequent refreshes are stored here.
  final ValueNotifier<Future<List<Member>>?> rideAttendeeFuture =
      ValueNotifier(null);

  static RideAttendeeFutureProvider of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<RideAttendeeFutureProvider>();

    assert(
      provider != null,
      'There is no RideAttendeeFutureProvider in the Widget tree.',
    );

    return provider!;
  }

  @override
  bool updateShouldNotify(RideAttendeeFutureProvider oldWidget) {
    return rideAttendeeFuture != oldWidget.rideAttendeeFuture;
  }
}
