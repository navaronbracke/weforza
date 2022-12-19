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
    if (ride.date.month.isEven) {
      final theme = Theme.of(context);

      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          return theme.primaryColor;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          return CupertinoTheme.of(context).primaryColor;
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
            ride.getFormattedDate(context, shortForm: false),
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
        android: (_) => ListTile(title: content),
        ios: (_) => Padding(
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
