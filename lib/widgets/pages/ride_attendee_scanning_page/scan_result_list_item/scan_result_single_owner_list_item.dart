import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/model/member.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

class ScanResultSingleOwnerListItem extends StatelessWidget {
  const ScanResultSingleOwnerListItem({
    Key? key,
    required this.owner,
  }) : super(key: key);

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
              android: () => const Icon(
                Icons.person,
                color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
              ),
              ios: () => const Icon(
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
  Widget _combineFirstNameAndAlias() {
    if (owner.alias.isEmpty) {
      return Text(
        '${owner.firstname} ${owner.lastname}',
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // Firstname 'alias'
    return Text.rich(
      TextSpan(text: owner.firstname, children: [
        TextSpan(
          text: " '${owner.alias}' ",
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(
          text: owner.lastname,
          style: const TextStyle(
            color: ApplicationTheme.rideAttendeeScanResultSingleOwnerColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ]),
      overflow: TextOverflow.ellipsis,
    );
  }
}
