import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents the attendee counter for a ride list item.
class RideListItemAttendeeCounter extends ConsumerStatefulWidget {
  const RideListItemAttendeeCounter({
    super.key,
    this.counterStyle,
    this.iconSize = 24,
    required this.rideDate,
  });

  /// The style for the counter.
  final TextStyle? counterStyle;

  /// The size for the counter icon.
  final double iconSize;

  /// The date of the ride to observe the count for.
  final DateTime rideDate;

  @override
  RideListItemAttendeeCounterState createState() {
    return RideListItemAttendeeCounterState();
  }
}

class RideListItemAttendeeCounterState
    extends ConsumerState<RideListItemAttendeeCounter> {
  Future<int>? future;

  void _getAttendeeCount() {
    future = ref
        .read(rideRepositoryProvider)
        .getRideAttendees(widget.rideDate)
        .then((value) => value.length);
  }

  @override
  void initState() {
    super.initState();
    _getAttendeeCount();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Ride?>(selectedRideProvider, (previous, next) {
      // If the selected ride was removed,
      // or the selected ride is not this ride anymore, abort.
      if (!mounted || next == null || next.date != widget.rideDate) {
        return;
      }

      // If the selected ride was set to this ride, abort.
      // The attendees are already loaded in initState().
      if (previous?.date != widget.rideDate && next.date == widget.rideDate) {
        return;
      }

      // Refresh the attendee count if this ride was updated.
      setState(_getAttendeeCount);
    });

    return FutureBuilder<int>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final count = snapshot.data;

          return Row(
            children: [
              Text('${count ?? '?'}', style: widget.counterStyle),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: PlatformAwareWidget(
                  android: () => Icon(
                    Icons.people,
                    size: widget.iconSize,
                    color: widget.counterStyle?.color,
                  ),
                  ios: () => Icon(
                    CupertinoIcons.person_2_fill,
                    size: widget.iconSize,
                    color: widget.counterStyle?.color,
                  ),
                ),
              ),
            ],
          );
        }

        return SizedBox.square(
          dimension: widget.iconSize,
          child: Center(
            child: PlatformAwareWidget(
              android: () => SizedBox.square(
                dimension: widget.iconSize * .8,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              ios: () => const CupertinoActivityIndicator(radius: 8),
            ),
          ),
        );
      },
    );
  }
}
