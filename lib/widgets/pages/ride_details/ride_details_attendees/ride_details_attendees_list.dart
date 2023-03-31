import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/riverpod/ride/selected_ride_provider.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/common/generic_error.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_empty.dart';
import 'package:weforza/widgets/pages/ride_details/ride_details_attendees/ride_details_attendees_list_item.dart';
import 'package:weforza/widgets/platform/cupertino_bottom_bar.dart';
import 'package:weforza/widgets/platform/platform_aware_loading_indicator.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class RideDetailsAttendeesList extends ConsumerWidget {
  const RideDetailsAttendeesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(selectedRideProvider);

    return FutureBuilder<List<Member>>(
      future: ride?.attendees,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.hasError) {
              return GenericError(text: S.of(context).GenericError);
            }

            final items = snapshot.data ?? [];

            if (items.isEmpty) {
              return const RideDetailsAttendeesListEmpty();
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      final member = items[index];

                      return RideDetailsAttendeesListItem(
                        firstName: member.firstname,
                        lastName: member.lastname,
                        alias: member.alias,
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
                _ScannedAttendeesBottomBar(
                  scanned: ride?.value.scannedAttendees,
                  total: items.length,
                ),
              ],
            );

          default:
            return const Center(child: PlatformAwareLoadingIndicator());
        }
      },
    );
  }
}

class _ScannedAttendeesBottomBar extends StatelessWidget {
  const _ScannedAttendeesBottomBar({
    Key? key,
    required this.total,
    required this.scanned,
  }) : super(key: key);

  final int total;

  final int? scanned;

  Widget _buildAndroidLayout(BuildContext context) {
    final translator = S.of(context);

    return BottomAppBar(
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
                      scanned == null ? '-' : '$scanned',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Icon(Icons.bluetooth_searching, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIosLayout() {
    return CupertinoBottomBar.tabBar(
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
              child: Text(
                '$total',
                style: const TextStyle(color: CupertinoColors.activeBlue),
              ),
            ),
            const Expanded(child: Center()),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                scanned == null ? '?' : '$scanned',
                style: const TextStyle(color: CupertinoColors.activeBlue),
              ),
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
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => _buildAndroidLayout(context),
      ios: () => _buildIosLayout(),
    );
  }
}
