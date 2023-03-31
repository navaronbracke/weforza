import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';

class ScanResultSingleOwnerListItem extends StatelessWidget {
  ScanResultSingleOwnerListItem({
    @required this.deviceName,
    @required this.owner,
  }): assert(owner != null && deviceName != null && deviceName.isNotEmpty);

  final String deviceName;
  final Member owner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SelectableText(deviceName, scrollPhysics: ClampingScrollPhysics()),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _formatDeviceOwnerNameLabel(context,owner.firstname,owner.lastname,owner.alias),
              style: ApplicationTheme.rideAttendeeScanResultOwnerLabelTextStyle,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  String _formatDeviceOwnerNameLabel(BuildContext context, String firstName, String lastName, String alias){
    final String text = alias == null || alias.trim().isEmpty ? "$firstName $lastName" : "$firstName '$alias' $lastName";

    return S.of(context).RideAttendeeScanningScanResultDeviceOwnedByLabel + text;
  }
}