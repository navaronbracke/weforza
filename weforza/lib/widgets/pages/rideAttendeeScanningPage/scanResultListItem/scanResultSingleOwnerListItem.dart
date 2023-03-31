import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/appTheme.dart';

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
            child: Icon(
              Icons.person,
              color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
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
              ),
            ),
            TextSpan(
              text: owner.lastname,
              style: TextStyle(
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
              ),
            ),
          ]
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}