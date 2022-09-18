import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/common/ride_list_item_attendee_counter.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a single item for the ride list page.
class RideListItem extends ConsumerWidget {
  const RideListItem({super.key, required this.ride});

  final Ride ride;

  Color? _getMonthColor(BuildContext context) {
    if (ride.date.month % 2 == 0) {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return Colors.blue;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return CupertinoColors.activeBlue;
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = TextStyle(color: _getMonthColor(context));

    final content = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            ride.getFormattedDate(context, false),
            style: style,
          ),
        ),
        RideListItemAttendeeCounter(
          key: ValueKey(ride.date),
          counterStyle: style,
          rideDate: ride.date,
        ),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: PlatformAwareWidget(
        android: () => ListTile(title: content),
        ios: () => Padding(
          padding: const EdgeInsets.all(12),
          child: content,
        ),
      ),
      onTap: () {
        ref.read(selectedRideProvider.notifier).setSelectedRide(ride);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RideDetailsPage()),
        );
      },
    );
  }
}
