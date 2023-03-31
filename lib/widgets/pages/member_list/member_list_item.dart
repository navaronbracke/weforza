import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weforza/model/rider/rider.dart';
import 'package:weforza/riverpod/rider/selected_rider_devices_provider.dart';
import 'package:weforza/riverpod/rider/selected_rider_provider.dart';
import 'package:weforza/widgets/common/member_name_and_alias.dart';
import 'package:weforza/widgets/common/rider_attending_count.dart';
import 'package:weforza/widgets/custom/profile_image/profile_image.dart';
import 'package:weforza/widgets/theme.dart';

class MemberListItem extends ConsumerWidget {
  MemberListItem({
    required this.member,
    required this.onPressed,
  }) : super(key: ValueKey(member.uuid));

  /// The rider that is displayed in this item.
  final Rider member;

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

        notifier.setSelectedRider(member);

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
              child: AdaptiveProfileImage.path(
                imagePath: member.profileImageFilePath,
                personInitials: member.initials,
              ),
            ),
            Expanded(
              child: MemberNameAndAlias.twoLines(
                alias: member.alias,
                firstLineStyle: textTheme.firstNameStyle,
                firstName: member.firstName,
                lastName: member.lastName,
                secondLineStyle: textTheme.lastNameStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: RiderListItemAttendingCount(rider: member),
            ),
          ],
        ),
      ),
    );
  }
}
