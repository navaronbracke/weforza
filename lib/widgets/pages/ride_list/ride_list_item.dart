import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/model/ride.dart';
import 'package:weforza/riverpod/repository/ride_repository_provider.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/ride_attendee_counter.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_page.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

/// This widget represents a single item for the ride list page.
class RideListItem extends ConsumerStatefulWidget {
  const RideListItem({Key? key, required this.ride}) : super(key: key);

  final Ride ride;

  @override
  RideListItemState createState() => RideListItemState();
}

class RideListItemState extends ConsumerState<RideListItem> {
  TextStyle get itemTextStyle {
    if (widget.ride.date.month % 2 == 0) {
      return const TextStyle(
        color: ApplicationTheme.rideListItemEvenMonthColor,
      );
    }

    return const TextStyle();
  }

  late Future<List<Member>> rideAttendees;

  @override
  void initState() {
    super.initState();

    final repository = ref.read(rideRepositoryProvider);
    rideAttendees = repository.getRideAttendees(widget.ride.date);
  }

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: <Widget>[
        Expanded(
          child: Text(
            widget.ride.getFormattedDate(context, false),
            style: itemTextStyle,
          ),
        ),
        RideAttendeeCounter(
          future: rideAttendees.then((list) => list.length),
          counterStyle: itemTextStyle,
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
        ref.read(selectedRideProvider.notifier).setSelectedRide(widget.ride);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const RideDetailsPage()),
        );
      },
    );
  }
}
