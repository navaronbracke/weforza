import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ScanResultListItem extends StatelessWidget {
  ScanResultListItem({
    @required this.item
  }): assert(item != null);

  final ScanResultItem item;

  @override
  Widget build(BuildContext context) {
    return PlatformAwareWidget(
      android: () => SizedBox(height: 45, child: _buildItem()),
      ios: () => SizedBox(height: 50, child: _buildItem()),
    );
  }

  Widget _buildItem(){
    return FutureBuilder<Member>(
        future: item.memberLookup,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return ScanResultError(deviceName: item.deviceName);
            }else{
              if(snapshot.data == null){
                return ScanResultOwnerNotFound(deviceName: item.deviceName);
              }else{
                return ScanResultOwnerFound(
                  deviceName: item.deviceName,
                  owner: snapshot.data,
                );
              }
            }
          }else{
            return ScanResultLoading(deviceName: item.deviceName);
          }
        },
      );
  }
}

class ScanResultLoading extends StatelessWidget {
  ScanResultLoading({@required this.deviceName}):
   assert(deviceName != null && deviceName.isNotEmpty);

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(deviceName, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: PlatformAwareLoadingIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanResultError extends StatelessWidget {
  ScanResultError({@required this.deviceName}):
   assert(deviceName != null && deviceName.isNotEmpty);

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(deviceName, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.error_outline,
              color: ApplicationTheme.rideAttendeeScanResultWarningColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ScanResultOwnerNotFound extends StatelessWidget {
  ScanResultOwnerNotFound({@required this.deviceName}):
   assert(deviceName != null && deviceName.isNotEmpty);

  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(deviceName, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Icon(
              Icons.help_outline,
              color: ApplicationTheme.rideAttendeeScanResultUnknownDeviceColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ScanResultOwnerFound extends StatelessWidget {
  ScanResultOwnerFound({
    @required this.deviceName,
    @required this.owner,
  }): assert(
    owner != null && deviceName != null && deviceName.isNotEmpty
  );

  final String deviceName;
  final Member owner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(deviceName, overflow: TextOverflow.ellipsis),
          SizedBox(height: 2),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  _formatDeviceOwnerNameLabel(context,owner.firstname,owner.lastname),
                  style: ApplicationTheme.rideAttendeeScanResultOwnerLabelTextStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _formatDeviceOwnerTelephoneLabel(context, owner.phone),
                  style: ApplicationTheme.rideAttendeeScanResultOwnerLabelTextStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDeviceOwnerNameLabel(BuildContext context, String firstName, String lastName){
    return "${S.of(context).RideAttendeeScanningScanResultDeviceOwnedByLabel}   $firstName $lastName";
  }

  String _formatDeviceOwnerTelephoneLabel(BuildContext context, String telephone){
    return "(${S.of(context).RideAttendeeScanningScanResultOwnerTelephoneLabel}$telephone)";
  }
}