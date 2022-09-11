import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_empty.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_item.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideDetailsAttendeesList extends ConsumerWidget {
  const RideDetailsAttendeesList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rideAttendees = ref.watch(selectedRideAttendeesProvider);

    return rideAttendees.when(
      data: (attendees) {
        if (attendees.isEmpty) {
          return const RideDetailsAttendeesListEmpty();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final member = attendees[index];

                  return RideDetailsAttendeesListItem(
                    firstName: member.firstname,
                    lastName: member.lastname,
                    alias: member.alias,
                  );
                },
                itemCount: attendees.length,
              ),
            ),
            _ScannedAttendeesBottomBar(total: attendees.length),
          ],
        );
      },
      error: (error, _) => GenericError(text: S.of(context).GenericError),
      loading: () => const Center(child: PlatformAwareLoadingIndicator()),
    );
  }
}

/// This widget represents the counter at the bottom of the ride attendees list.
/// This counter displays the total amount of ride attendees
/// and the number of scanned attendees.
class _ScannedAttendeesBottomBar extends ConsumerWidget {
  const _ScannedAttendeesBottomBar({required this.total});

  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedAttendees = ref.watch(
      selectedRideProvider.select((value) => value?.scannedAttendees),
    );

    final translator = S.of(context);

    return PlatformAwareWidget(
      android: () => BottomAppBar(
        color: ApplicationTheme.primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Tooltip(
                message: translator.Total,
                child: Row(
                  children: [
                    const Icon(Icons.people, color: Colors.white),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '$total',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: Center()),
              Tooltip(
                message: translator.Scanned,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        '${scannedAttendees ?? '-'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const Icon(
                      Icons.bluetooth_searching,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      ios: () {
        const textStyle = TextStyle(color: CupertinoColors.activeBlue);

        return CupertinoBottomBar.constrained(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.person_2_fill,
                  color: CupertinoColors.activeBlue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text('$total', style: textStyle),
                ),
                const Expanded(child: Center()),
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text('${scannedAttendees ?? '-'}', style: textStyle),
                ),
                const Icon(
                  Icons.bluetooth_searching,
                  color: CupertinoColors.activeBlue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
