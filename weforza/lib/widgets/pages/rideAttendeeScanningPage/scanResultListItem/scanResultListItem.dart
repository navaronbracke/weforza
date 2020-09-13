import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/model/member.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultListItemWithDeviceNameAndIconSlot.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/scanResultListItem/scanResultSingleOwnerListItem.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ScanResultListItem extends StatelessWidget {
  ScanResultListItem({ @required this.item }): assert(item != null);

  final ScanResultItem item;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => SizedBox(height: 45, child: _buildItem()),
      ios: () => SizedBox(height: 50, child: _buildItem()),
    );
  }

  Widget _buildItem(){
    return FutureBuilder<List<Member>>(
        future: item.findDeviceOwners,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return ScanResultListItemWithDeviceNameAndIconSlot(
                deviceName: item.deviceName,
                iconBuilder: () => Icon(
                  Icons.error_outline,
                  color: ApplicationTheme.rideAttendeeScanResultWarningColor,
                ),
              );
            }else{
              if(snapshot.data == null || snapshot.data.isEmpty){
                return ScanResultListItemWithDeviceNameAndIconSlot(
                  deviceName: item.deviceName,
                  iconBuilder: () => Icon(
                    Icons.help_outline,
                    color: ApplicationTheme.rideAttendeeScanResultUnknownDeviceColor,
                  ),
                );
              }else{
                if(snapshot.data.length == 1){
                  return ScanResultSingleOwnerListItem(
                    deviceName: item.deviceName,
                    owner: snapshot.data.first,
                  );
                }else{
                  //TODO multiple items -> owner selection widget (close dropdown upon selecting a new one of these)
                  //TODO device name should also be selectable text here
                  return Center();//temporary until we get a new widget here
                }
              }
            }
          }else{
            return ScanResultListItemWithDeviceNameAndIconSlot(
              deviceName: item.deviceName,
              iconBuilder: () => PlatformAwareLoadingIndicator(),
            );
          }
        },
      );
  }
}

