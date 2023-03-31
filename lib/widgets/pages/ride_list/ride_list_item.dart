import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/ride_list_item_attendee_counter.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a single item for the ride list page.
class RideListItem extends ConsumerWidget {
  const RideListItem({super.key, required this.ride});

  final Ride ride;

  TextStyle get itemTextStyle {
    if (ride.date.month % 2 == 0) {
      return const TextStyle(
        color: ApplicationTheme.rideListItemEvenMonthColor,
      );
    }

    return const TextStyle();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            ride.getFormattedDate(context, false),
            style: itemTextStyle,
          ),
        ),
        RideListItemAttendeeCounter(
          key: ValueKey(ride.date),
          counterStyle: itemTextStyle,
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
