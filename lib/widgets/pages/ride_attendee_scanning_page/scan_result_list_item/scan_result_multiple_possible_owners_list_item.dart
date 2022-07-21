import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weforza/generated/l10n.dart';
import 'package:weforza/theme/app_theme.dart';
import 'package:weforza/widgets/platform/platform_aware_widget.dart';

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
    final translator = S.of(context);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: PlatformAwareWidget(
                    android: () => const Icon(
                      Icons.people,
                      color: ApplicationTheme.multipleOwnerColor,
                    ),
                    ios: () => const Icon(
                      CupertinoIcons.person_2_fill,
                      color: ApplicationTheme.multipleOwnerColor,
                    ),
                  ),
                ),
                SelectableText(
                  deviceName,
                  scrollPhysics: const ClampingScrollPhysics(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              translator.AmountOfRidersWithDeviceName(amountOfPossibleOwners),
              style: ApplicationTheme.multipleOwnersLabelStyle,
            ),
          ),
        ],
      ),
    );
  }
}
