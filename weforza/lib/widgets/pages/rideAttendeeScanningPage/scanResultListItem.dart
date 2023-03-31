import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/model/member.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/scanResultItem.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class ScanResultListItem extends StatelessWidget {
  ScanResultListItem({
    @required this.item
  }): assert(item != null);

  final ScanResultItem item;

  Widget _buildErrorItem(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(item.deviceName, overflow: TextOverflow.ellipsis),
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

  Widget _buildNotFoundItem(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(item.deviceName, overflow: TextOverflow.ellipsis),
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

  Widget _buildLoadingItem(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(item.deviceName, overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: PlatformAwareLoadingIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceWithOwnerItem(BuildContext context, Member owner){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item.deviceName),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: FutureBuilder<Member>(
        future: item.memberLookup,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return _buildErrorItem();
            }else{
              if(snapshot.data == null){
                return _buildNotFoundItem();
              }else{
                return _buildDeviceWithOwnerItem(context,snapshot.data);
              }
            }
          }else{
            return _buildLoadingItem();
          }
        },
      ),
    );
  }
}
