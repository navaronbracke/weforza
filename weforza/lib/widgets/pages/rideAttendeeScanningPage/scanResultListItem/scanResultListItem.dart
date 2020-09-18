import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:flutter/material.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultListItemWithDeviceNameAndIconSlot.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultSingleOwnerListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class ScanResultListItem extends StatelessWidget {
  ScanResultListItem({
    @required this.deviceName,
    @required this.findDeviceOwners,
    @required this.multipleOwnersBuilder,
  }): assert(
    findDeviceOwners != null && deviceName != null && deviceName.isNotEmpty
        && multipleOwnersBuilder != null
  );

  /// A [Future] that returns the owners for a device with [deviceName] as name.
  final Future<List<Member>> findDeviceOwners;

  /// The device name to display in the widget.
  final String deviceName;

  /// This builder function builds a scan result item
  /// for a device name with multiple possible owners.
  final Widget Function(String deviceName, List<Member> owners) multipleOwnersBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Member>>(
        future: findDeviceOwners,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return ScanResultListItemWithDeviceNameAndIconSlot(
                deviceName: deviceName,
                iconBuilder: () => Icon(
                  Icons.error_outline,
                  color: ApplicationTheme.rideAttendeeScanResultWarningColor,
                ),
              );
            }else{
              if(snapshot.data == null || snapshot.data.isEmpty){
                return ScanResultListItemWithDeviceNameAndIconSlot(
                  deviceName: deviceName,
                  iconBuilder: () => Icon(
                    Icons.help_outline,
                    color: ApplicationTheme.rideAttendeeScanResultUnknownDeviceColor,
                  ),
                );
              }else{
                return snapshot.data.length == 1 ? ScanResultSingleOwnerListItem(
                  deviceName: deviceName,
                  owner: snapshot.data.first,
                ): multipleOwnersBuilder(deviceName, snapshot.data);
              }
            }
          }else{
            return ScanResultListItemWithDeviceNameAndIconSlot(
              deviceName: deviceName,
              iconBuilder: () => PlatformAwareLoadingIndicator(),
            );
          }
        },
      );
  }
}

