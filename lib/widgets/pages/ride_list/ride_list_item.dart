import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/database/database.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/utils/date_format_utils.dart';
import 'package:weforza/widgets/common/ride_list_item_attendee_counter.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a single item for the ride list page.
class RideListItem extends ConsumerWidget {
  const new({required this.ride, super.key});

  final Ride ride;

  Color? _getMonthColor(BuildContext context) {
    if (ride.date.month.isEven) {
      return switch (defaultTargetPlatform) {
        .android || .fuchsia || .linux || .windows => ColorScheme.of(context).primary,
        .iOS || .macOS => CupertinoTheme.of(context).primaryColor,
      };
    }

    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = TextStyle(color: _getMonthColor(context));

    final content = Row(
      children: <Widget>[
        Expanded(
          child: Text(ride.date.formatWithPattern(context, pattern: .long), style: style),
        ),
        RideListItemAttendeeCounter(key: ValueKey(ride.date), counterStyle: style, rideDate: ride.date),
      ],
    );

    return GestureDetector(
      behavior: .opaque,
      child: PlatformAwareWidget(
        android: (_) => ListTile(title: content),
        ios: (_) => Padding(padding: const .all(12), child: content),
      ),
      onTap: () {
        ref.read(selectedRideProvider.notifier).setSelectedRide(ride);

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RideDetailsPage()));
      },
    );
  }
}
