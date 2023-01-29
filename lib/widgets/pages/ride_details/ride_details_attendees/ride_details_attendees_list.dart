import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_empty.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_item.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';
import 'package:weforza/widgets/theme.dart';

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
                  final attendee = attendees[index];

                  return RideDetailsAttendeesListItem(
                    firstName: attendee.firstName,
                    lastName: attendee.lastName,
                    alias: attendee.alias,
                  );
                },
                itemCount: attendees.length,
              ),
            ),
            _ScannedAttendeesBottomBar(total: attendees.length),
          ],
        );
      },
      error: (error, _) => const Center(child: GenericError()),
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

  Widget _buildAndroidLayout(
    BuildContext context, {
    required int total,
    int? scannedAttendees,
  }) {
    final translator = S.of(context);

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: AppTheme.colorScheme,
      ),
      child: BottomAppBar(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              margin: const EdgeInsets.only(bottom: 12),
              message: translator.Total,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.people, color: AppTheme.colorScheme.primary),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text('$total'),
                  ),
                ],
              ),
            ),
            Tooltip(
              margin: const EdgeInsets.only(bottom: 12),
              message: translator.Scanned,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${scannedAttendees ?? '-'}'),
                  Icon(
                    Icons.bluetooth_searching,
                    color: AppTheme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosLayout(
    BuildContext context, {
    required int total,
    int? scannedAttendees,
  }) {
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
              child: Text('$total'),
            ),
            const Expanded(child: Center()),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text('${scannedAttendees ?? '-'}'),
            ),
            const Icon(
              Icons.bluetooth_searching,
              color: CupertinoColors.activeBlue,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scannedAttendees = ref.watch(
      selectedRideProvider.select((value) => value?.scannedAttendees),
    );

    return PlatformAwareWidget(
      android: (context) => _buildAndroidLayout(
        context,
        scannedAttendees: scannedAttendees,
        total: total,
      ),
      ios: (context) => _buildIosLayout(
        context,
        scannedAttendees: scannedAttendees,
        total: total,
      ),
    );
  }
}
