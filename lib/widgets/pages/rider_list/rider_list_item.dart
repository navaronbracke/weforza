import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/rider/selected_rider_devices_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/rider_attending_count.dart';
import 'package:weforza/widgets/common/rider_name_and_alias.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/theme.dart';

class RiderListItem extends ConsumerWidget {
  RiderListItem({
    required this.rider,
    required this.onPressed,
  }) : super(key: ValueKey(rider.uuid));

  /// The rider that is displayed in this item.
  final Rider rider;

  /// The onTap handler for this item.
  ///
  /// This function is called after the selected rider was updated.
  final void Function() onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const textTheme = AppTheme.riderTextTheme;

    return GestureDetector(
      onTap: () {
        final notifier = ref.read(selectedRiderProvider.notifier);

        notifier.setSelectedRider(rider);

        ref.invalidate(selectedRiderDevicesProvider);

        onPressed();
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: AdaptiveProfileImage(
                image: rider.profileImage,
                personInitials: rider.initials,
              ),
            ),
            Expanded(
              child: RiderNameAndAlias.twoLines(
                alias: rider.alias,
                firstLineStyle: textTheme.firstNameStyle,
                firstName: rider.firstName,
                lastName: rider.lastName,
                secondLineStyle: textTheme.lastNameStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: RiderListItemAttendingCount(rider: rider),
            ),
          ],
        ),
      ),
    );
  }
}
