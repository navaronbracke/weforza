import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/appTheme.dart';

class ScanResultMultiplePossibleOwnersListItem extends StatelessWidget {
  ScanResultMultiplePossibleOwnersListItem({
    @required this.deviceName,
    @required this.amountOfPossibleOwners
  }): assert(
    deviceName != null && deviceName.isNotEmpty &&
        amountOfPossibleOwners != null && amountOfPossibleOwners > 1
  );


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
                  child: Icon(
                      Icons.device_unknown,
                      color: ApplicationTheme.rideAttendeeScanResultUnknownDeviceColor
                  ),
                ),
                SelectableText(deviceName, scrollPhysics: ClampingScrollPhysics()),
              ],
            ),
          ),
          Text(
            S.of(context).RideAttendeeScanningDeviceWithMultiplePossibleOwnersLabel(amountOfPossibleOwners),
            style: ApplicationTheme.rideAttendeeScanResultMultipleOwnersLabelStyle,
          ),
        ],
      ),
    );
  }
}
