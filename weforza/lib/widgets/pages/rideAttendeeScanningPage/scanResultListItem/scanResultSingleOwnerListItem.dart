import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/platform/platformAwareWidget.dart';

class ScanResultSingleOwnerListItem extends StatelessWidget {
  ScanResultSingleOwnerListItem({
    required this.owner
  });

  final Member owner;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: PlatformAwareWidget(
              android: () => Icon(
                Icons.person,
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
              ),
              ios: () => Icon(
                CupertinoIcons.person_fill,
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
              ),
            ),
          ),
          _combineFirstNameAndAlias(),
        ],
      ),
    );
  }

  //Combine the first name with the alias.
  Widget _combineFirstNameAndAlias(){
    if(owner.alias.isEmpty){
      return Text(
        "${owner.firstname} ${owner.lastname}",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // Firstname 'alias'
    return Text.rich(
      TextSpan(
          text: owner.firstname,
          children: [
            TextSpan(
              text: " '${owner.alias}' ",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: owner.lastname,
              style: TextStyle(
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ]
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}