import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ScanResultMultiplePossibleOwnersListItem extends StatelessWidget {
  ScanResultMultiplePossibleOwnersListItem({
    Key? key,
    required this.deviceName,
    required this.amountOfPossibleOwners,
  })  : assert(deviceName.isNotEmpty && amountOfPossibleOwners > 1),
        super(key: key);

  final String deviceName;
  final int amountOfPossibleOwners;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: PlatformAwareWidget(
                    android: () => const Icon(
                      Icons.people,
                      color: ApplicationTheme
                          .rideAttendeeScanResultMultipleOwnerColor,
                    ),
                    ios: () => const Icon(
                      CupertinoIcons.person_2_fill,
                      color: ApplicationTheme
                          .rideAttendeeScanResultMultipleOwnerColor,
                    ),
                  ),
                ),
                SelectableText(deviceName,
                    scrollPhysics: const ClampingScrollPhysics()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(
              S
                  .of(context)
                  .RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel(
                      amountOfPossibleOwners),
              style: ApplicationTheme
                  .rideAttendeeScanResultMultipleOwnersLabelStyle,
            ),
          ),
        ],
      ),
    );
  }
}
